require 'faker'
require 'open-uri'
require 'rss'

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
  user.remote_profile_pic_url = Faker::Avatar.image
  user.save!
end

tim_search = JSON.parse(open('https://itunes.apple.com/search?term=t&media=podcast&entity=podcast').read)
puts 'creating podcasts and episodes...'
tim_search['results'].each do |podcast|
  s = podcast['collectionId']
  pod = Podcast.new(name: podcast['collectionName'], balance: 50, creator: User.all.sample)
  pod.remote_artwork_url = podcast['artworkUrl100']
  pod.save!
  url = "https://itunes.apple.com/lookup?id=#{s}"
  search = JSON.parse(open(url).read)
  rss_url = search['results'][0]['feedUrl']
  rss = RSS::Parser.parse(rss_url, false)
  rss.items.first(15).each do |item|
    Episode.create!(name: item.title, podcast: pod)
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
    b = Bookmark.create!(user: user, donation: d)
    Notification.create!(user: d.user, bookmark: b)
  end
end

puts 'creating notifications'
