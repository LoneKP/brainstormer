class User < ApplicationRecord

  has_many :brainstorms, as: :facilitated_by, dependent: :destroy
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :messages, class_name: "Ahoy::Message", as: :user

  pay_customer stripe_attributes: :stripe_attributes
  pay_customer default_payment_processor: :stripe

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, 
         :confirmable, :lockable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates_presence_of     :name, message: "Don't forget to let other brainstormers know what to call you. Write your name!"
  
  validates_presence_of     :email, message: "Hey there! You forgot to write your email", only: :create
  validates_uniqueness_of   :email, allow_blank: true, case_sensitive: true, if: :email_changed?
  validates_format_of       :email, with: Devise::email_regexp, allow_blank: true, if: :email_changed?
  
  validates_presence_of     :password, if: :password_required?, message: "Don't forget to come up with your super secret password"
  validates_length_of       :password, if: :password_required?, within: 6..128, allow_blank: true, message: "Don't make you password too easy to guess. It needs to contain at least 6 characters"
  validates_confirmation_of :password, if: :password_required?, message: "It looks like your password confirmation doesn't match the password"

  validates_acceptance_of :privacy_policy_agreement, allow_nil: false, on: :create

  def after_confirmation
    send_welcome_email
  end

  after_create :send_welcome_email_oauth

  def hobbyist_plan?
    !payment_processor.subscribed?
  end

  def facilitator_plan?
    payment_processor.subscribed?
  end

  def paid_plan?
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

  def oauth_user?
    provider.present? && uid.present?
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

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)
    
    if user
      user.skip_confirmation! 
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      return user
    end

    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.privacy_policy_agreement = true
      user.skip_confirmation!
    end
  end

  def send_welcome_email_oauth
    if oauth_user?
      OnboardingMailer.with(user: self).welcome_email.deliver_later
      send_usage_tip_email
    end
  end

  def send_welcome_email
    OnboardingMailer.with(user: self).welcome_email.deliver_later
    send_usage_tip_email
  end

  def send_usage_tip_email
    Mailer::SendOutUsageTipJob.set(wait: 3.weeks).perform_later(self.id)
  end

  protected
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  
end
