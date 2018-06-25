class AddNewFeedToPodcasts < ActiveRecord::Migration[5.2]
  def change
    add_column :podcasts, :new_feed, :string
  end
end
