# frozen_string_literal: true

# Used to handle the register function
class RegistrationsController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)
    if user.save
      sign_in(:user, user)
      flash[:success] = '登録に成功してログインしました。'
      redirect_to root_path
    else
      flash[:danger] = user.errors.full_messages
      redirect_to new_user_registration_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
