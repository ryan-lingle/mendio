class AddChangeToDonations < ActiveRecord::Migration[5.2]
  def change
    change_column :donations, :amount, :decimal
  end
end
