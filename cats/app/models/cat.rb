class Cat < ActiveRecord::Base
  COLORS = ['blue', 'green']

  validates :birth_date, :color, :name, :sex, :user_id, presence: true
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: ['M', 'F'] }

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id,
    inverse_of: :cats

  has_many :rental_requests,
            class_name: "CatRentalRequest",
            foreign_key: :cat_id,
            dependent: :destroy

  def age
    ((Time.now - self.birth_date.to_time) / 1.year).floor
  end

end
