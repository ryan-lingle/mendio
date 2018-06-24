class AddFieldsToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :number, :integer
    add_column :episodes, :description, :text
  end
end
