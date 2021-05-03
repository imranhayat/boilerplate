# frozen_string_literal: true

module Plans
  # :Interactor for Plan Creation:
  class CreatePlan < BaseInteractor
    def call
      if check_product_exists?
        make_plan_on_stripe
      else
        context.fail! message: 'Atleast one product must exists!'
      end
    end

    def check_product_exists?
      return true if Product.count >= 1
    end

    def make_plan_on_stripe
      plan = Product.first.plans.new(context.plan_params)
      response = PaymentGatewayAdapter.new(
        payment_gateway: payment_gateway,
        object: plan
      ).call
      if response[:success] == true
        make_plan_in_app(plan)
      else
        context.fail! message: response[:error]
      end
    end

    def make_plan_in_app(plan)
      if plan.save!
        context.plan = plan
      else
        context.fail message: 'Something went wrong!'
      end
    end

    def payment_gateway
      Product.first.payment_gateway
    end
  end
end
