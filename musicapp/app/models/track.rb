class Track < ActiveRecord::Base
  KINDS = %w{ bonus regular }

  validates :title, :album_id, :kind, presence: true
  validates :kind, inclusion: KINDS

  belongs_to :album, inverse_of: :tracks
  has_one :band, through: :album, source: :band
  has_many :notes, dependent: :destroy

end
