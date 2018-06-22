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
  has_many :saved_donations, through: :bookmarks, source: :donation
  has_many :notifications, dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :viewed_donations, through: :views, source: :donation
  mount_uploader :profile_pic, ProfilePicUploader
  after_create :send_welcome_email
  include PgSearch
  PgSearch.multisearch_options = { using: { tsearch: { prefix: true, dictionary: "english" } } }
  multisearchable against: [ :username ]
  attr_accessor :seed

  def feed
    feed = []
    self.following.each do |user|
      user.donations.each do |donation|
        feed << donation
      end
    end
    self.donations.each { |d| feed << d }
    feed = feed.sort_by { |donation| -donation.amount }
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

  private

    def send_welcome_email
      return if seed
      UserMailer.welcome(self).deliver_now
    end
end
