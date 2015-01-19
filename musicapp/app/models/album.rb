class Album < ActiveRecord::Base
  KINDS = %w{ live studio }

  validates :title, :band_id, :kind, presence: true
  validates :kind, inclusion: KINDS

  belongs_to :band, inverse_of: :albums
  has_many :tracks, dependent: :destroy
end
