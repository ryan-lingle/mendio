class AddArtworkToPodcasts < ActiveRecord::Migration[5.2]
  def change
    add_column :podcasts, :artwork, :string
  end
end
