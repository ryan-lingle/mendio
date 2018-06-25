class AddSeenToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :seen, :boolean, default: false
  end
end
