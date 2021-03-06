# frozen_string_literal: true

# Used to handle responses from RPs
class OmniauthCallbacksController < ApplicationController
  def callback
    user_info = request.env['omniauth.auth'].info
    user = User.find_by_email(user_info.email)
    if user.nil?
      password = SecureRandom.base64(8)
      user = User.create(email: user_info.email, password: password)
    end

    sign_in(:user, user)
    redirect_to root_path
  end
end
