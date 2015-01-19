class Note < ActiveRecord::Base
  validates :body, :user_id, :track_id, presence: true

  belongs_to :user, inverse_of: :notes
  belongs_to :track, inverse_of: :notes

end
