class AddIndexToCatRentalRequestUserId < ActiveRecord::Migration
  def change
    add_index :cat_rental_requests, :user_id
  end
end
