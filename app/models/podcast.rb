require 'nokogiri'
require 'open-uri'

class Podcast < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  has_many :donations, through: :episodes
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  validates_presence_of :name
  validates_presence_of :artwork
  validates_presence_of :creator
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

  def self.rss_builder(user, url)
    doc = Nokogiri::XML(open(url))
    if user.email == doc.at('//itunes:email').text
      podcast = Podcast.new(
        creator: user,
        name: doc.at('//title').text,
        description: doc.at('//description').text
      )
      podcast.remote_artwork_url = doc.at('//itunes:image')['href']
      podcast.save!
      doc.xpath('//item').each do |ep|
        episode = Episode.new(
          name: ep.xpath('.//title').text,
          podcast: podcast,
        )
        episode.number = ep.at('.//itunes:episode').text if ep.at('.//itunes:episode')
        episode.description = ep.at('.//itunes:summary').text if ep.at('.//itunes:summary')
        episode.save!
      end
      return true
    end
    return false
  end
end
