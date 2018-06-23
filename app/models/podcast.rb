require 'nokogiri'
require 'open-uri'

class Podcast < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  has_many :donations, through: :episodes
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  validates_presence_of :name
  # validates :name, uniqueness: true
  mount_uploader :artwork, ArtworkUploader
  include PgSearch
  PgSearch.multisearch_options = { using: { tsearch: { prefix: true, dictionary: "english" } } }
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }
  multisearchable against: [ :name ]

  def build_podcast(url)
    doc = Nokogiri::XML(open(url))
    if current_user.email == doc.at('//itunes:email').text
      podcast = Podcast.new(
        creator: current_user,
        name: doc.at('//title').text,
      )
      podcast.remote_artwork_url = doc.at('//itunes:image')['href']
      if podcast.save!
        return true
      end
    end
    return false
  end
end
