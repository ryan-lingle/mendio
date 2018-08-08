class AddDonationToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :donation, foreign_key: true
  end
end
