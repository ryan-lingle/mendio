require 'faker'
require 'open-uri'
require 'nokogiri'

User.destroy_all
Relationship.destroy_all
Bookmark.destroy_all
Notification.destroy_all
Podcast.destroy_all
Donation.destroy_all
Episode.destroy_all


puts 'creating users...'
5.times do
  name = Faker::FunnyName.name.split(' ')
  user = User.new(
    first_name: name[0],
    last_name: name[1],
    username: name.join('_').downcase,
    balance: 10,
    email: Faker::Internet.email,
    password: 'mendiopassword',
    seed: true,
  )
  user.remote_profile_pic_url = 'http://i.pravatar.cc/300'
  user.save!
end

tim_search = JSON.parse(open('https://itunes.apple.com/search?term=t&media=podcast&entity=podcast').read)
puts 'creating podcasts and episodes...'
tim_search['results'].first(5).each do |podcast|
  begin
    s = podcast['collectionId']
    puts "Creating #{podcast['collectionName']}..."
    pod = Podcast.new(
      name: podcast['collectionName'],
      balance: 50,
      creator: User.all.sample,
    )
    url = "https://itunes.apple.com/lookup?id=#{s}"
    search = JSON.parse(open(url).read)
    rss_url = search['results'][0]['feedUrl']
    doc = Nokogiri::XML(open(rss_url))
    if doc.at('//itunes:summary')
      pod.description = doc.at('//itunes:summary').text
    end
    pod.remote_artwork_url = doc.at('//itunes:image')['href']
    if doc.at('//itunes:new-feed-url')
      pod.new_feed = doc.at('//itunes:new-feed-url').text
    end
    pod.save!
    doc.xpath('//item').first(15).each do |ep|
      begin
        episode = Episode.new(
          name: ep.xpath('.//title').text,
          podcast: pod,
        )
        if ep.at('.//itunes:summary')
          episode.description = ep.at('.//itunes:summary').text
        end
        if ep.at('.//itunes:episode')
          episode.number = ep.at('.//itunes:episode').text
        end
        episode.save!
      rescue => ex
        puts ex.message
      end
    end
  rescue => ex
    puts ex.message
  end
end

# puts 'creating donations...'
# 40.times do
#   Donation.create(user: User.all.sample, description: 'A great podcast!', episode: Episode.all.sample, influencer: User.all.sample, amount: rand(1..10))
# end

# puts 'creating relationships...'
# User.all.each do |user|
#   4.times do
#     other_user = User.all.sample
#     while user == other_user || user.following.include?(other_user)
#       other_user = User.all.sample
#     end
#     user.follow(other_user)
#     Notification.create!(user: other_user, follower: user)
#   end
# end

# puts 'creating bookmarks...'
# User.all.each do |user|
#   3.times do
#     d = Donation.all.sample
#     while user.saved_episodes.include?(d.episode)
#       d = Donation.all.sample
#     end
#     b = Bookmark.create!(user: user, episode: d.episode)
#     Notification.create!(user: d.user, bookmark: b)
#   end
# end

puts 'creating notifications'
