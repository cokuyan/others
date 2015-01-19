class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :user_name, uniqueness: true

  after_save :ensure_session_token

  has_many :cats, dependent: :destroy

  has_many :rental_requests,
            class_name: "CatRentalRequest",
            foreign_key: :user_id,
            dependent: :destroy

  has_many :sessions, dependent: :destroy

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  # def reset_session_token!
  #   self.session_token = self.class.generate_session_token
  #   self.save!
  #   self.session_token
  # end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    Session.create!(user_id: self.id, session_token: User.generate_session_token)
  end
end
