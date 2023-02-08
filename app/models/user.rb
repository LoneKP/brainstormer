class User < ApplicationRecord
  
  has_many :brainstorms, as: :facilitated_by, dependent: :destroy
  has_many :visits, class_name: "Ahoy::Visit"

  pay_customer stripe_attributes: :stripe_attributes
  pay_customer default_payment_processor: :stripe

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

  validates_acceptance_of :privacy_policy_agreement, allow_nil: false, on: :create

  def hobbyist_plan?
    !payment_processor.subscribed?
  end

  def facilitator_plan?
    payment_processor.subscribed?
  end

  def plan
    if hobbyist_plan?
      1
    elsif facilitator_plan?
      2
    else
      1
    end
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        #city: pay_customer.owner.city,
        #country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id # or pay_customer.owner_id
      }
    }
  end

  protected
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  
end
