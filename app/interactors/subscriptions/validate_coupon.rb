# frozen_string_literal: true

module Subscriptions
  # :Interactor for Cancelling the Subscription right away:
  class ValidateCoupon < BaseInteractor
    def call
      response = StripeAdapter.new(
        object: context.coupon
      ).call
      if response[:success] == true
        context.coupon = response[:coupon]
      else
        context.fail! message: response[:message]
      end
    end
  end
end
