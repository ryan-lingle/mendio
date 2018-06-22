# frozen_string_literal: true

class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  belongs_to :influencer, class_name: "User", optional: true
  has_many :bookmarks, dependent: :destroy
  has_many :user_saves, through: :bookmarks, source: :user
  has_many :views, dependent: :destroy
  has_many :user_views, through: :views, source: :user
  validates_uniqueness_of :user, :scope => [:influencer]
end
