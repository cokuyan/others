class User < ActiveRecord::Base
  attr_reader :password

  validates :email, :session_token, :activation_token, presence: true
  validates :session_token, :email, :activation_token, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank"}
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token
  after_initialize :ensure_activation_token
  after_initialize :default_activation
  after_initialize :default_admin

  has_many :notes, dependent: :destroy

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.generate_activation_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def ensure_activation_token
    self.activation_token ||= self.class.generate_activation_token
  end

  def default_activation
    self.activated ||= false
  end

  def default_admin
    self.admin ||= false
  end
end
