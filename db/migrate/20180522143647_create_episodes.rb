class CreateEpisodes < ActiveRecord::Migration[5.1]
  def change
    create_table :episodes do |t|
      t.string :name
      t.references :podcast, foreign_key: true
      t.timestamps
    end
  end
end
