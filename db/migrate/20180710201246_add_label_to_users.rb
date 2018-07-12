class AddLabelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :label, :string
    add_column :podcasts, :label, :string
  end
end
