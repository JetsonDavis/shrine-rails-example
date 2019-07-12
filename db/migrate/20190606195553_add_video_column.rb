class AddVideoColumn < ActiveRecord::Migration[5.2]
  def change
  	add_column :photos, :video, :text
  end
end
