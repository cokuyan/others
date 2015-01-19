class FixAlbumAndTrackTables < ActiveRecord::Migration
  def change
    add_column :albums, :kind, :string, null: false
  end
end
