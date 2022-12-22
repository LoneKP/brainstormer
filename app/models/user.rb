class User < ApplicationRecord
  has_many :brainstorms, as: :facilitated_by, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable, :lockable, :trackable

  validates_presence_of     :name, message: "Don't forget to let other brainstormers know what to call you. Write your name!"
  
  validates_presence_of     :email, message: "Hey there! You forgot to write your email", only: :create
  validates_uniqueness_of   :email, allow_blank: true, case_sensitive: true, if: :email_changed?
  validates_format_of       :email, with: Devise::email_regexp, allow_blank: true, if: :email_changed?
  
  validates_presence_of     :password, if: :password_required?, message: "Don't forget to come up with your super secret password"
  validates_length_of       :password, if: :password_required?, within: 6..128, allow_blank: true, message: "Don't make you password too easy to guess. It needs to contain at least 6 characters"
  validates_confirmation_of :password, if: :password_required?, message: "It looks like your password confirmation doesn't match the password"

  #validates_presence_of     :current_password, unless: :encrypted_password_changed?, message: "We need your current password to confirm your changes"

  protected
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  #validates_presence_of   :current_password, message: "You need to write your current password"


         

        #  validates :password, length: { message: "Don't make you password too easy to guess. It needs to contain at least 6 characters"}, :on => :create

         
       

        #  validates_presence_of     :password,
        #  validates_confirmation_of :password
        #  validates_length_of       :password, within: 6..8, 
  
end
