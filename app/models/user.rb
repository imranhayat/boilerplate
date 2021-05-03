# frozen_string_literal: true

# :User Model:
class User < ApplicationRecord
  # Roles
  rolify
  # Devise modules
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :invitable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]
  # Validations
  validates_uniqueness_of :email
  # User Balance Settings
  monetize :balance_cents, as: 'balance'
  # Paperclip Settings
  has_attached_file :profile_pic, styles: { medium: '300x300',
                                            small: '150x150' },
                                  default_url: '/avatar.png'
  validates_attachment_content_type :profile_pic,
                                    content_type: /\Aimage\/.*\z/

  after_create :assign_default_role

  def assign_default_role
    user = self
    user.add_role(:normal) if user.roles.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = SecureRandom.hex(8)
    end
  end

  def self.total_normal_users
    Role.find_by_name('normal').users.count
  end

  # Subscriptions
  has_one :subscription, dependent: :destroy

  def card_details
    payment_method = stripe_customer_payment_method
    {
      brand: payment_method.card.brand.capitalize,
      last4: payment_method.card.last4,
      exp_month: payment_method.card.exp_month,
      exp_year: payment_method.card.exp_year
    }
  end

  def stripe_customer_payment_method
    Stripe::PaymentMethod.retrieve(stripe_payment_method_id)
  end

  def create_stripe_customer
    if stripe_customer_id.present?
    else
      customer = make_customer_on_stripe
      update!(stripe_customer_id: customer.id)
    end
    stripe_customer_id
  end

  def make_customer_on_stripe
    Stripe::Customer.create(
      email: email,
      name: name
    )
  end

  def stripe_invoices
    Stripe::Invoice.list(customer: stripe_customer_id) if stripe_customer_id
  end

  def self.total_subscribed_users
    User.where(payment_status: true).count
  end

  def self.all_stripe_invoices_amount_count
    sum = 0
    @user = Role.find_by_name('normal').users
    @user.each do |user|
      if user.stripe_customer_id.present?
        sum += Stripe::Invoice.list(customer: user.stripe_customer_id)
                              .map(&:amount_paid).sum
      end
    end
    sum
  end

  def self.all_invoices
    invoices = []
    @user = Role.find_by_name('normal').users
    @user.each do |user|
      if user.stripe_customer_id.present?
        invoices << Stripe::Invoice.list(customer: user.stripe_customer_id)
      end
    end
    invoices.flatten
  end

  def self.find_invoice_user(customer_id)
    @user = User.find_by_stripe_customer_id(customer_id)
    { name: @user.name, email: @user.email }
  end

  def name
    unless first_name.present? && last_name.present?
      ''      
    else
      "#{first_name} #{last_name}"    
    end
  end
end
