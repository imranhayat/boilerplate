# frozen_string_literal: true

module Subscriptions
  # :Interactor for Creating a Subscription:
  class UpOrDownStripePlan < BaseInteractor
    def call
      response = StripeAdapter.new.change_plan(
        context.current_user,
        context.plan
      )
      if response[:success] == true
        context.response = response
      else
        context.fail! message: response[:message]
      end
    end
  end
end
