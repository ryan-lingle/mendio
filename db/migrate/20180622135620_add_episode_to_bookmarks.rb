class AddEpisodeToBookmarks < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bookmarks, :donation
    add_reference :bookmarks, :episode, foreign_key: true
  end
end
