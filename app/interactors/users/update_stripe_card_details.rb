# frozen_string_literal: true

# Users Module
module Users
  # :Interactor for Updating user credit card details:
  class UpdateStripeCardDetails < BaseInteractor
    def call
      update_card_details
    rescue Stripe::InvalidRequestError,
           Stripe::StripeError,
           Stripe::APIConnectionError,
           Stripe::CardError,
           Stripe::RateLimitError,
           Stripe::AuthenticationError => e
      context.fail! message: e.message
    end

    def update_card_details
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        client_reference_id: context.current_user.id,
        mode: 'setup',
        expand: ['setup_intent'],
        success_url: 'http://localhost:3000/user_settings?response=Success',
        cancel_url: 'http://localhost:3000/user_settings?response=Failure'
      )
      context.session = session
    end
  end
end
