class AddDescriptionToDonation < ActiveRecord::Migration[5.2]
  def change
    add_column :donations, :description, :text
  end
end
