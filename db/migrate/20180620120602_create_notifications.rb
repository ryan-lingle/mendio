class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :bookmark, foreign_key: true
      t.integer :follower_id

      t.timestamps
    end
    add_index :notifications, :follower_id
  end
end
