# frozen_string_literal: true

# :Payment Gateway Adapter for detecting payment gateway and make API:
# :calls accordingly:
class PaymentGatewayAdapter
  def initialize(options = {})
    @payment_gateway = options[:payment_gateway]
    @object = options[:object]
    @params = options[:params] || nil
  end

  def call
    make_adapter_call
  end

  def make_adapter_call
    if @payment_gateway == 'Stripe'
      stripe_call
    else
      paypal_call
    end
  end

  def stripe_call
    StripeAdapter.new(
      object: @object,
      params: @params
    ).call
  end

  def paypal_call
    PaypalAdapter.new(
      object: @object,
      params: @params
    ).call
  end
end
