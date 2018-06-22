require 'faker'
require 'open-uri'
require 'rss'

Relationship.destroy_all
Bookmark.destroy_all
Notification.destroy_all

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
    b = Bookmark.create!(user: user, episode: d.episode)
    Notification.create!(user: d.user, bookmark: b)
  end
end

puts 'creating notifications'
