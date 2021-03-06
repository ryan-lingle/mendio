# frozen_string_literal: true

class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :donations, dependent: :destroy
  validates_presence_of :name
  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }
  validates :podcast, presence: true
  has_many :bookmarks, dependent: :destroy
  has_many :user_saves, through: :bookmarks, source: :user

  def revenue
    sum = 0
    self.donations.each { |d| sum += d.amount }
    sum
  end

end
