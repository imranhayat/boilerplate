# frozen_string_literal: true

# :PayPal Adapter for making API calls to PayPal:
class PaypalAdapter
  def initialize(options = {})
    @object = options[:object]
    @params = options[:params] || nil
  end

  def call
    p 'Implement Paypal Gateway Nigga!'
  end
end
