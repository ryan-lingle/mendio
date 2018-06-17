class CreatePodcasts < ActiveRecord::Migration[5.1]
  def change
    create_table :podcasts do |t|
      t.string :name
      t.references :creator
      t.integer :balance, default: 0, null:false
      t.timestamps
    end
  end
end
