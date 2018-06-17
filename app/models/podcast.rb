class Podcast < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  has_many :donations, through: :episodes
  validates_presence_of :name
  validates :name, uniqueness: true
  mount_uploader :artwork, ArtworkUploader
end
