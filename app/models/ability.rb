# frozen_string_literal: true

# :Ability class to handle Application authorization:
class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :read, :all
      cannot :update, :all
      cannot :destroy, :all
      can :manage, :admin_panel
      cannot :manage, :user_panel
      can :manage, Product
      can :manage, Plan
      can :invoices, :user_panel
    elsif user.has_role? :normal
      cannot :manage, :all
      can :manage, :user_panel
      can :index, Plan
      can :manage, Subscription
    else
      cannot :manage, :all
    end
  end
end
