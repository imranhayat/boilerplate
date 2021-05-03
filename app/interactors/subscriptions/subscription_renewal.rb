# frozen_string_literal: true

# :Subscription Module:
module Subscriptions
  # :Interactor for allowing or cancelling the renewal of subscription:
  class SubscriptionRenewal < BaseInteractor
    def call
      update_stripe_subscription_renewal
    rescue Stripe::InvalidRequestError,
           Stripe::StripeError,
           Stripe::APIConnectionError,
           Stripe::CardError,
           Stripe::RateLimitError,
           Stripe::AuthenticationError => e
      context.fail! message: e.message
    end

    def update_stripe_subscription_renewal
      subscription = context.current_user.subscription
      Stripe::Subscription.update(
        subscription.stripe_id,
        cancel_at_period_end: !subscription.cancel_at_period_end
      )
    end
  end
end
