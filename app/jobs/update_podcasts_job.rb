require 'open-uri'
require 'nokogiri'

class UpdatePodcastsJob < ApplicationJob
  queue_as :default

  def perform(podcast_id)
    podcast = Podcast.find(podcast_id)
    if podcast.new_feed
      doc = Nokogiri::XML(open(podcast.new_feed))
      puts "Updating #{doc.at('//title').text}"
      podcast.name = doc.at('//title').text
      podcast.description = doc.at('//itunes:summary').text
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
    end
  end
end
