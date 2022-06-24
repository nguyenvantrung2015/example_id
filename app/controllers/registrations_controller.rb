class RegistrationsController < ApplicationController
  def new ;end
  def new2 ;end
  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = "登録に成功しました。"
      redirect_to root_path
    else
      flash[:danger] = user.errors.full_messages
      redirect_to sign_up_new_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email,:password, :password_confirmation)
  end
end
