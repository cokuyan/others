class AddActivatedFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activated, :boolean, null: false, default: false
  end
end
