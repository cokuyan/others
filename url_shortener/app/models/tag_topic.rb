class TagTopic < ActiveRecord::Base
  validates :tag_name, presence: true, uniqueness: true

  has_many :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_id,
    primary_key: :id

  has_many :urls, through: :taggings, source: :url

  def most_popular_links
    self.urls
      .select('shortened_urls.*')
      .joins('INNER JOIN visits ON shortened_urls.id = visits.url_id')
      .group('shortened_urls.long_url')
      .order('COUNT(visits.visitor_id) DESC')
      .limit(5)
  end
end
