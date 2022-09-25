class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  def password
    @password
  end
  
  def password=(raw)
    @password = raw
    self.password_digest = BCrypt::Password.create(raw)
  end

  def is_password?(raw)
    BCrypt::Password.new(password_digest).is_password?(raw)
  end
end
