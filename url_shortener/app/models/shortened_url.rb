class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true,
                                        length: { maximum: 1024 }
  validate :no_more_than_five_per_minute

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :url_id,
    primary_key: :id

  has_many :taggings,
    class_name: 'Tagging',
    foreign_key: :url_id,
    primary_key: :id

  has_many :visitors, -> { distinct }, through: :visits, source: :visitor

  has_many :tags, through: :taggings, source: :tag

  def self.random_code
    begin
      code = SecureRandom::urlsafe_base64
    end while self.exists?(code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code = self.random_code
    self.create!(submitter_id: user.id, short_url: code, long_url: long_url)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where('visits.created_at > ?', 10.minutes.ago).count
  end

  def tag(tag_name)
    tag = TagTopic.find_by_name(tag_name)
    Tagging.tag_url_with_tag!(self, tag)
  end

  private

  def no_more_than_five_per_minute
    num = self.submitter.submitted_urls
            .where('shortened_urls.created_at > ?', 1.minute.ago)
            .count
    if num > 5
      errors[:base] << "can't make more than five URLs per minute"
    end
  end
end
