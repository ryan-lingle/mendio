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
        description: doc.at('//itunes:summary').text
      )
      podcast.remote_artwork_url = doc.at('//itunes:image')['href']
      podcast.new_feed = doc.at('//itunes:new-feed-url').text if doc.at('//itunes:new-feed-url')
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
      return podcast
    end
    return false
  end

  def revenue
    sum = 0
    self.donations.each { |d| sum += d.amount }
    sum
  end

  def top_episodes
    self.episodes.sort_by { |e| -e.revenue }.first(5)
  end

  def address
    BlockIo.get_address_by_label(label: label)['data']['address']
  end

  def balance
    BlockIo.get_address_by_label(label: label)['data']['available_balance']
  end
end
