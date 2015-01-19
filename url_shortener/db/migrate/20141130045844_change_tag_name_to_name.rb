class ChangeTagNameToName < ActiveRecord::Migration
  def change
    rename_column :tag_topics, :tag_name, :name
  end
end
