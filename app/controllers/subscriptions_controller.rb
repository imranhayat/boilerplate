# frozen_string_literal: true

# :Subscriptions Controller for Handling Subscription Actions:
class SubscriptionsController < ApplicationController
  load_and_authorize_resource

  def create
    @response = create_subscription
    @payment_attrs = @response.payment_attrs
    respond_to do |format|
      format.html do
        if @response.success?
          redirect_to user_settings_path,
                      notice: 'You have subscribed our services successfully'
        else
          redirect_to user_settings_path, alert: "Error: #{response.message}"
        end
      end
      format.js
    end
  end

  def create_subscription
    Subscriptions::CreateSubscription.call(
      params: params,
      current_user: current_user
    )
  end

  def cancel_subscription_now
    response = Subscriptions::CancelSubscriptionNow.call(
      current_user: current_user
    )
    if response.success?
      redirect_to user_settings_path,
                  notice: 'Your Subscription has been cancelled successfully.'
    else
      redirect_to user_settings_path,
                  alert: "Stripe Error: #{response.message}"
    end
  end

  def setup_renewal_of_subscription
    response = Subscriptions::SubscriptionRenewal.call(
      current_user: current_user
    )
    if response.success?
      redirect_to user_settings_path, notice: 'Subscription Update Successfully'
    else
      redirect_to user_settings_path,
                  alert:
          "Stripe error while updating subscription: #{response.message}"
    end
  end

  def validate_coupon
    @response = Subscriptions::ValidateCoupon.call(coupon: params[:coupon])
    respond_to do |format|
      if @response.success?
        apply_discount(@response)
        format.html { redirect_to request.referer, notice: 'Coupon Verified' }
      else
        format.html { redirect_to request.referer, alert: @response.message }
      end
      format.js
    end
  end

  def apply_discount(response)
    @plan = Plan.find_by_stripe_id(params[:stripe_plan_id])
    @discounted_amount = discounted_amount(response.coupon, @plan.amount_decimal)
  end

  def collect_payment_details
    @plan = Plan.find(params[:app_plan_id])
    @app_plan_id = params[:app_plan_id]
    @stripe_plan_id = params[:stripe_plan_id]
    respond_to do |format|
      format.js
    end
  end

  def fetch_payment_details
    @plan = Plan.find(params[:plan])
    @app_plan_id = @plan.id
    @stripe_plan_id = @plan.stripe_id
    @card_last_4 = current_user.card_details[:last4]
    respond_to do |format|
      format.js
    end
  end

  def upgrade_or_downgrade_stripe_plan
    @plan = Plan.find(params[:plan])
    @response = up_or_down_stripe_plan(@plan)
    if @response.success?
      redirect_to user_settings_path,
                  notice: 'Your Subscription plan is changed successfully.'
    else
      redirect_to user_settings_path,
                  alert: "Error: #{@response.message}"
    end
  end

  def up_or_down_stripe_plan(plan)
    Subscriptions::UpOrDownStripePlan.call(
      current_user: current_user,
      plan: plan
    )
  end

  private

  def discounted_amount(coupon, original_amount)
    if coupon.percent_off.present?
      original_amount - ((original_amount * coupon.percent_off) / 100)
    elsif coupon.amount_off.present?
      original_amount - (coupon.amount_off / 100)
    end
  end
end
