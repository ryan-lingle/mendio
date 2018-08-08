class AddAccountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_id, :string
    add_column :users, :account, :boolean, default: false
  end
end
