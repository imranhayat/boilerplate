# frozen_string_literal: true

# :Users Controller:
class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to profile_path, notice: 'User profile updated successfully'
    else
      redirect_to profile_path, notice: @user.errors.full_messages.join
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :date_of_birth, :gender,
                                 :profile_pic)
  end
end
