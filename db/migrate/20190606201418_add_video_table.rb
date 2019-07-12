class AddVideoTable < ActiveRecord::Migration[5.2]
  def change
  	 create_table :videos do |t|
      t.references(:album, foreign_key: true)
      t.string :title
      t.text :video_data
    end
  end
end
