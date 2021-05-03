# frozen_string_literal: true

# :Stripe Configuration:
Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['SECRET_KEY'],
  end_point_secret: ENV['ENDPOINT_SECRET']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2019-03-14'
