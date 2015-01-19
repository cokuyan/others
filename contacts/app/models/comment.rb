class Comment < ActiveRecord::Base
  validates :commentable_id, :presence => true
  validates :commentable_type, :presence => true
  validates :body, :presence => true

  belongs_to :commentable, polymorphic: true
end
