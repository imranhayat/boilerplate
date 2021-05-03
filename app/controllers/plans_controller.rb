# frozen_string_literal: true

# :Plans Controller for managing plan actions:
class PlansController < ApplicationController
  load_and_authorize_resource
  before_action :set_plan, only: %i[show]

  def index
    @plans = Plan.all
    @monthly_plans = Plan.where(interval: 'month')
    @yearly_plans = Plan.where(interval: 'year')
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'All Plans'
    @current_user_plan = current_user&.subscription&.plan
  end

  def show; end

  # GET /plans/new
  def new
    @plan = Plan.new
    add_breadcrumb 'Admin Panel', admin_panel_path,
                   title: 'Back to the Admin Panel'
    add_breadcrumb 'All Plans', plans_path,
                   title: 'Back to the All Plans'
    add_breadcrumb 'Add New Plan'
  end

  # POST /plans
  def create
    response = Plans::CreatePlan.call(plan_params: plan_params)
    if response.success?
      redirect_to plans_path, notice: 'Plan was successfully created.'
    else
      redirect_to new_plan_path, alert: "Plan Error: #{response.message}"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def plan_params
    params.require(:plan).permit(:nickname, :amount_decimal, :currency,
                                 :interval, :interval_count)
  end
end
