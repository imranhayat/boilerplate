# frozen_string_literal: true

# :Stripe Manager for handling webhooks for Stripe Events:
class StripeWebhookManager
  def initialize(read_body_request, request, params)
    @read_body_request = read_body_request
    @request = request
    @params = params
  end

  def call
    ensuring_security
    handle_events
  end

  def ensuring_security
    # To Ensure the Security that the events are coming from a trusted source
    payload = @read_body_request
    sig_header = @request.env['HTTP_STRIPE_SIGNATURE']
    begin
      Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET']
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      # Invalid payload, Invalid signature
      { body: nil, status: :bad_request, message: e.message }
    end
  end

  # Different Events Handling
  def handle_events
    case @params[:type]
    when 'payment_intent.succeeded'
      update_user
    when 'payment_intent.payment_failed'
      cancel_payment_intent
      change_user_status
    when 'invoice.payment_succeeded'
      set_up_subscription
    when 'invoice.payment_failed'
      change_app_subscription_status
    when 'customer.subscription.updated'
      update_subscription
    when 'customer.subscription.deleted'
      change_app_subscription_status
    when 'customer.updated'
      update_customer
    when 'checkout.session.completed'
      update_user_payment_method
    else
      handle_bad_requests
    end
  end

  def cancel_payment_intent
    intent_id = @params[:data][:object][:id]
    Stripe::PaymentIntent.cancel(intent_id)
  rescue Stripe::InvalidRequestError => e
    { message: e.message }
  end

  def change_user_status
    user_email =
      @params[:data][:object][:last_payment_error][:payment_method][:billing_details][:email]
    return unless user_email.present?

    user = User.find_by_email(user_email)
    return unless user.present?

    user.update(payment_status: false)
  end

  def update_user
    stripe_customer =
      @params[:data][:object][:charges][:data][0][:customer]
    return unless stripe_customer.present?

    customer_object = Stripe::Customer.retrieve(stripe_customer)
    user_email = customer_object.email
    user = User.find_by_email(user_email)
    user.update!(payment_status: true) if user.present?
  end

  def set_up_subscription
    if @params[:data][:object][:billing_reason] == 'subscription_create'
      create_subscription_in_app
    else
      update_subscription
    end
  end

  def create_subscription_in_app
    user_id = @params[:data][:object][:lines][:data][0][:metadata][:user]
    return unless user_id.present?

    user = User.find(user_id)
    return unless user.present?

    return unless @params[:data][:object][:status] == 'paid'

    subscribe_user_to_app(user)
  end

  def subscribe_user_to_app(user)
    if user.subscription.present?
      manage_subscription_accordingly(user.subscription)
    else
      subscription = user.build_subscription(subscription_params)
      manage_subscription_accordingly(subscription)
    end
  end

  def subscription_params
    {
      plan_id: @params[:data][:object][:lines][:data][0][:metadata][:plan_id]
    }
  end

  def manage_subscription_accordingly(subscription)
    params = @params[:data][:object][:lines][:data][0]
    subscription.update!(
      active: true,
      stripe_id: params[:subscription],
      cancel_at_period_end: false,
      current_period_start: params[:period][:start],
      current_period_end: params[:period][:end],
      plan_id: params[:metadata][:plan_id]
    )
  end

  def update_subscription
    return unless fetch_subscription.present?

    fetch_subscription.update!(
      cancel_at_period_end: @params[:data][:object][:cancel_at_period_end],
      current_period_start: @params[:data][:object][:current_period_start],
      current_period_end: @params[:data][:object][:current_period_end]
    )
    check_plan_change
    check_subscription_status
  end

  def check_plan_change
    return unless @params[:data][:object][:metadata][:plan_id].present?

    fetch_subscription.update!(
      plan_id: @params[:data][:object][:metadata][:plan_id]
    )
  end

  def check_subscription_status
    return if @params[:data][:object][:status] == 'active'

    fetch_subscription.update!(active: false)
  end

  def change_app_subscription_status
    return unless fetch_subscription.present?

    fetch_subscription.user.update!(payment_status: false)
    fetch_subscription.update!(active: false)
  end

  def fetch_subscription
    Subscription.find_by_stripe_id(@params[:data][:object][:id])
  end

  def update_customer
    customer = User.find_by_stripe_customer_id(@params[:data][:object][:id])
    return unless customer.present?

    customer.update!(
      stripe_payment_method_id:
      @params[:data][:object][:invoice_settings][:default_payment_method]
    )
  end

  def update_user_payment_method
    user_id = @params[:data][:object][:client_reference_id]
    user = User.find_by_id(user_id)
    return unless user.present?

    intent = setup_intent
    payment_method_id = intent.payment_method
    user.update!(stripe_payment_method_id: payment_method_id)
    Stripe::PaymentMethod.attach(payment_method_id,
                                 customer: user.create_stripe_customer)
    update_default_payment_method(user.stripe_customer_id, payment_method_id)
  end

  def setup_intent
    Stripe::SetupIntent.retrieve(@params[:data][:object][:setup_intent])
  end

  def update_default_payment_method(customer_id, payment_method_id)
    Stripe::Customer.update(
      customer_id,
      invoice_settings: {
        default_payment_method: payment_method_id
      }
    )
  end

  def handle_bad_requests
    { body: nil, status: :bad_request }
  end
end
