class CreateContact < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.integer :user_id
    end
    add_index :contacts, [:email, :user_id], :unique => true
    add_index :contacts, :user_id
  end
end
