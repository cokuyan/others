class Tagging < ActiveRecord::Base
  validates :tag_id, presence: true
  validates :url_id, presence: true

  belongs_to :tag,
    class_name: 'TagTopic',
    foreign_key: :tag_id,
    primary_key: :id

  belongs_to :url,
    class_name: 'ShortenedUrl',
    foreign_key: :url_id,
    primary_key: :id

  def self.tag_url_with_tag!(url, tag)
    self.create!(url_id: url.id, tag_id: tag.id)
  end

end
