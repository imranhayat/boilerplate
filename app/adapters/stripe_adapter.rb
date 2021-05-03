# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe:
class StripeAdapter
  # This functions takes the object and the params, the object should be
  # product, plan, subscription or coupon and the params should be anything.
  def initialize(options = {})
    @object = options[:object] || nil
    @params = options[:params] || nil
  end

  def call
    check_call_from
  end

  def check_call_from
    if @object.class.to_s == 'Product'
      call_product_api
    elsif @object.class.to_s == 'Plan'
      call_plan_api
    elsif @object.class.to_s == 'Subscription'
      call_subscription_api
    else
      call_coupon_api
    end
  end

  def call_product_api
    create_product
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def create_product
    stripe_product = Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    update_product(stripe_product)
    { success: true }
  end

  def update_product(stripe_product)
    @object.update!(stripe_id: stripe_product.id)
  end

  def call_plan_api
    create_plan
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def create_plan
    stripe_plan = Stripe::Plan.create(
      currency: @object.currency,
      interval: @object.interval,
      interval_count: @object.interval_count,
      product: @object.product.stripe_id,
      nickname: @object.nickname,
      amount_decimal: @object.amount_decimal * 100
    )
    update_plan(stripe_plan)
    { success: true }
  end

  def update_plan(stripe_plan)
    @object.update!(stripe_id: stripe_plan.id)
  end

  def call_subscription_api
    create_customer unless stripe_customer_exists?
    create_subscription
  end

  def stripe_customer_exists?
    current_user.stripe_customer_id.present? &&
      current_user.stripe_payment_method_id.present?
  end

  def create_customer
    make_customer
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def current_user
    @object.user
  end

  def make_customer
    stripe_customer = Stripe::Customer.create(
      email: current_user.email,
      name: current_user.name,
      payment_method: @params[:payment_method],
      invoice_settings: {
        default_payment_method: @params[:payment_method]
      }
    )
    update_customer_in_app(stripe_customer)
  end

  def update_customer_in_app(stripe_customer)
    current_user.update!(stripe_customer_id: stripe_customer.id,
                         stripe_payment_method_id: @params[:payment_method])
  end

  def create_subscription
    subscription = make_subscription
    perform_several_actions(subscription)
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def make_subscription
    Stripe::Subscription.create(
      customer: current_user.stripe_customer_id,
      coupon: @params[:coupon_id],
      metadata: { user: current_user.id, plan_id: @object.plan_id },
      items: [
        {
          plan: @params[:stripe_plan_id]
        }
      ],
      expand: ['latest_invoice.payment_intent']
    )
  end

  def perform_several_actions(subscription)
    payment_intent = subscription.latest_invoice.payment_intent
    setup_payment_attrs(payment_intent, subscription)
  end

  def setup_payment_attrs(payment_intent, subscription)
    {
      payment_intent_status: payment_intent&.status,
      payment_intent_client_secret: payment_intent&.client_secret,
      stripe_subscription_status: subscription&.status,
      subscription: subscription,
      success: true
    }
  end

  def call_coupon_api
    verify_coupon
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, message: e.message }
  end

  def verify_coupon
    coupon = Stripe::Coupon.retrieve(@object)
    { success: true, coupon: coupon }
  end

  def change_plan(current_user, plan)
    stripe_subscription = retrieve_subscription(current_user)
    call_subscription_update_api(stripe_subscription, plan)
  end

  def retrieve_subscription(current_user)
    Stripe::Subscription.retrieve(
      current_user.subscription.stripe_id
    )
  end

  def call_subscription_update_api(stripe_subscription, plan)
    update_stripe_subscription(stripe_subscription, plan)
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, message: e.message }
  end

  def update_stripe_subscription(stripe_subscription, plan)
    Stripe::Subscription.update(
      stripe_subscription.id,
      cancel_at_period_end: false,
      metadata: { plan_id: plan.id },
      items: [
        {
          id: stripe_subscription.items.data[0].id,
          plan: plan.stripe_id
        }
      ]
    )
    { success: true }
  end
end
