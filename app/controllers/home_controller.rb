# frozen_string_literal: true

# :Home Controller:
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :stripe_webhooks

  def stripe_webhooks
    StripeWebhookManager.new(
      request.body.read,
      request,
      params
    ).call
  end
end
