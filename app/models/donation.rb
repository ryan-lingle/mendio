class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  belongs_to :influencer, :class_name => 'User'
  has_many :bookmarks, dependent: :destroy
  has_many :user_saves, through: :bookmarks, source: :user
  # validates_uniqueness_of :user, :scope => [:influencer]
end