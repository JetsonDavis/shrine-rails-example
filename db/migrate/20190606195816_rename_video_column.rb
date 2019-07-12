class RenameVideoColumn < ActiveRecord::Migration[5.2]
  def change
  	rename_column :photos, :video, :video_data
  end
end
