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
25.times do
  user = User.new(
    username: Faker::Internet.user_name,
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
tim_search['results'].each do |podcast|
  begin
    s = podcast['collectionId']
    puts "Creating #{podcast['collectionName']}..."
    pod = Podcast.new(
      name: podcast['collectionName'],
      balance: 50,
      creator: User.all.sample,
    )
    if s
      url = "https://itunes.apple.com/lookup?id=#{s}"
    end
    search = JSON.parse(open(url).read)
    rss_url = search['results'][0]['feedUrl']
    if rss_url
      doc = Nokogiri::XML(open(rss_url))
      if doc.at('//itunes:summary')
        pod.description = doc.at('//itunes:summary').text
      end
      if doc.at('//itunes:image')
        pod.remote_artwork_url = doc.at('//itunes:image')['href']
      end
      pod.save!
      doc.xpath('//item').first(15).each do |ep|
        if ep.xpath('.//title') && ep.at('.//itunes:episode') && ep.at('.//description')
          Episode.create!(
            name: ep.xpath('.//title').text,
            number: ep.at('.//itunes:episode').text,
            description: ep.at('.//description').text,
            podcast: pod,
          )
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => invalid
    puts invalid.record.errors
  rescue Cloudinary::CarrierWave::UploadError
    puts 'image not found'
  rescue OpenURI::HTTPError => ex
    puts "Missing feed skipped"
  end
 end

puts 'creating donations...'
150.times do
  Donation.create(user: User.all.sample, description: 'A great podcast!', episode: Episode.all.sample, influencer: User.all.sample, amount: rand(1..10))
end

puts 'creating relationships...'
User.all.each do |user|
  10.times do
    other_user = User.all.sample
    while user == other_user || user.following.include?(other_user)
      other_user = User.all.sample
    end
    user.follow(other_user)
    Notification.create!(user: other_user, follower: user)
  end
end

puts 'creating bookmarks...'
User.all.each do |user|
  3.times do
    d = Donation.all.sample
    while user.saved_episodes.include?(d.episode)
      d = Donation.all.sample
    end
    b = Bookmark.create!(user: user, episode: d.episode)
    Notification.create!(user: d.user, bookmark: b)
  end
end

puts 'creating notifications'
