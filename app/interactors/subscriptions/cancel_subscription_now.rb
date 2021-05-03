# frozen_string_literal: true

module Subscriptions
  # :Interactor for Cancelling the Subscription right away:
  class CancelSubscriptionNow < BaseInteractor
    def call
      delete_stripe_subscription
    end

    def current_user
      context.current_user
    end

    def delete_stripe_subscription
      delete_subscription
    rescue Stripe::InvalidRequestError,
           Stripe::StripeError,
           Stripe::APIConnectionError,
           Stripe::RateLimitError,
           Stripe::AuthenticationError => e
      context.fail! message: e.message
    end

    def delete_subscription
      stripe_subscription = Stripe::Subscription.retrieve(
        current_user.subscription.stripe_id
      )
      stripe_subscription.delete
    end
  end
end
