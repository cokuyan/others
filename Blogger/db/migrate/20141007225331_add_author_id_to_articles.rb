class AddAuthorIdToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :author, index: true
  end
end
