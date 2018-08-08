# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :donations, dependent: :destroy
  has_many :influenced_donations, class_name: "Donation", foreign_key: "influencer_id"
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followed_by, through: :passive_relationships, source: :follower
  has_many :bookmarks, dependent: :destroy
  has_many :saved_episodes, through: :bookmarks, source: :episode
  has_many :notifications, dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :viewed_donations, through: :views, source: :donation
  has_many :podcasts, class_name: 'Podcast', foreign_key: "creator_id"
  mount_uploader :profile_pic, ProfilePicUploader
  # after_create :send_welcome_email
  include PgSearch
  PgSearch.multisearch_options = { using: { tsearch: { prefix: true, dictionary: "english" } } }
  multisearchable against: [ :username ]
  attr_accessor :seed
  validate :account_exists

  def account_exists
    if account == true
      User.validates :account_id, presence: true, uniqueness: true
    end
  end

  def feed
    feed = []
    self.following.each do |user|
      user.donations.each do |donation|
        feed << donation
      end
    end
    self.donations.each { |d| feed << d }
    feed = feed.sort_by { |donation| -donation.amount }
    seen_unseen = feed.partition { |d| !self.viewed_donations.include?(d) }
    feed = seen_unseen.flatten
  end

  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followed_by.include?(other_user)
  end

  def has_seen?(episode)
    self.viewed_donations.each do |d|
      if episode == d.episode
        return d.user
      end
    end
    false
  end

  def notification_count
    unseen = self.notifications.select { |n| n.unseen? }
    unseen.count > 0 ? "(#{unseen.count})" : ""
  end

  def create_account(params, ip)
    account = Stripe::Account.create(
      type: 'custom',
      country: 'US',
      email: self.email
    )
    account.legal_entity.address.city = params[:city]
    account.legal_entity.address.line1 = params[:line1]
    account.legal_entity.address.line2 = params[:line2] if params[:line2].present?
    account.legal_entity.address.postal_code = params[:postal_code]
    account.legal_entity.address.state = params[:state]
    account.legal_entity.dob.day = params[:day]
    account.legal_entity.dob.month = params[:month]
    account.legal_entity.dob.year = params[:year]
    account.legal_entity.first_name = self.first_name
    account.legal_entity.last_name = self.last_name
    account.legal_entity.ssn_last_4 = params[:ssn]
    account.legal_entity.type = 'individual'
    account.tos_acceptance.date = Time.now.to_time.to_i
    account.tos_acceptance.ip = ip
    account.external_accounts.create(external_account: params[:stripeToken])
    account.payout_schedule.interval = 'manual'
    account.debit_negative_balances = true
    account.save
    self.account_id = account.id
    self.account = true
    self.save!
  end

  private

    def send_welcome_email
      return if seed
      UserMailer.welcome(self).deliver_now
    end
end
