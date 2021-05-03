# frozen_string_literal: true

# :Admin Panel Controller:
class AdminPanelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: false

  def index
    @users = User.where.not(id: current_user.id)
    add_breadcrumb 'Admin Panel'
  end

  def users
    @users = User.where.not(id: current_user.id).order('created_at DESC')
                 .includes(subscription: :plan)
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'All Users'
  end

  def all_invoices
    @invoices = User.all_invoices
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'All Invoices'
  end

  def change_access
    @user = User.find(params[:enable] || params[:disable])
    if params[:enable].present?
      @access = 'Enabled'
      @user.update(revoke_access: false)
    else
      @access = 'Disabled'
      @user.update(revoke_access: true)
    end
    redirect_to admin_users_path, notice: "#{@user.email} has been #{@access}"
  end
end
