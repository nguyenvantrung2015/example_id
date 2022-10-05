# frozen_string_literal: true

# WebauthnAssertionsController
class WebauthnAssertionsController < ApplicationController
  def index; end

  def create
    webauthn_credential = WebAuthn::Credential.from_get(params[:authnResponse])
    stored_credential = WebauthnCredential.find_by(external_id: webauthn_credential.id)
    if verify_webauthn(webauthn_credential, stored_credential)
      user = User.find(stored_credential.user_id)
      sign_in(:user, user)
      flash[:success] = 'Successfully Login'
      render status: :ok, json: { message: 'Successfully Login' }
    else
      render status: :unprocessable_entity, json: { message: 'Failure Login' }
    end
  end

  def options
    user = User.find_by(email: params[:email])
    allowed_credentials = user&.webauthn_credentials&.pluck(:external_id)

    if allowed_credentials
      args = { user_verification: :required }.merge!(allow: allowed_credentials)
      authn_options = WebAuthn::Credential.options_for_get(**args)
      session[:current_authentication] = {
        allow: authn_options.allow,
        authentication_challenge: authn_options.challenge
      }
      render status: :ok, json: { publicKey: authn_options }
    else
      flash[:danger] = 'Your account is not registered'
      render status: :unprocessable_entity, json: { message: 'Your account is not registered'}
    end
  end

  private

  def verify_webauthn(webauthn_credential, stored_credential)
    current_authentication = session.delete(:current_authentication)

    return false if current_authentication.blank? || current_authentication['allow'].exclude?(webauthn_credential.id)

    webauthn_credential.verify(
      current_authentication['authentication_challenge'],
      public_key: stored_credential.public_key,
      sign_count: 0
    )
  end
end
