namespace :podcast do
  desc "Updating all Podcast RSS Feeds"
  task :update_all => :environment do
    podcasts = Podcast.all
    puts "Enqueuing update of #{podcasts.size} podcasts..."
    podcasts.each do |podcast|
      UpdatePodcastsJob.perform_later(podcast.id)
    end
    # rake task will return when all jobs are _enqueued_ (not done).
  end
end
