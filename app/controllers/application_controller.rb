# frozen_string_literal: true

# :Application Controller:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User) and resource.has_role? :admin
        admin_panel_path
      elsif resource.is_a?(User)
        user_panel_path
      else
        super
      end
  end

  def trial_expired?
    return unless user_signed_in?

    return if current_user.has_role?(:admin)

    return unless helpers.remaining_days <= 0

    return if current_user.subscription.present?

    redirect_to plans_path,
                alert: 'Your trial period has ended, please select a plan to continue using Project'
  end
end
