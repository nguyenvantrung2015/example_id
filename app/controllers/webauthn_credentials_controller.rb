# frozen_string_literal: true

# WebauthnCredentialsController
class WebauthnCredentialsController < ApplicationController
  before_action :authenticate_user!

  def index
    @webauthns = current_user&.webauthn_credentials
  end

  def create
    @public_key_credential = WebAuthn::Credential.from_create(create_params)
    challenge = session[:webauthn_credential_attestation]['challenge']
    @public_key_credential&.verify(challenge)

    ApplicationRecord.transaction do
      current_user.webauthn_id || current_user.create_webauthn_id!(webauthn_id: webauthn_id)
      current_user.webauthn_credentials.create!(
        external_id: @public_key_credential.id,
        public_key: @public_key_credential.public_key
      )
    end

    session.delete(:webauthn_credential_attestation)
    flash[:success] = 'Create a security device successfully'
    render status: :ok, json: { message: 'Create a security device successfully' }
  rescue StandardError
    flash[:danger] = 'Create a security device failure'
    render status: :unprocessable_entity, json: { message: 'Create a security device failure' }
  end

  def destroy
    webauthn_credential = current_user&.webauthn_credentials.find_by(params[:id])
    if webauthn_credential.destroy
      flash[:success] = 'Delete the security device successfully'
    else
      flash[:danger] = 'Delete the security device fail'
    end
    redirect_to webauthn_credentials_path
  end

  def options
    registration_params = {
      user: { id: webauthn_id, name: current_user.email },
      exclude: current_user.webauthn_credentials.pluck(:external_id),
      authenticator_selection: {
        authenticator_attachment: 'platform',
        user_verification: 'required',
        resident_key: 'preferred'
      }
    }
    registration_options = WebAuthn::Credential.options_for_create(registration_params)
    session[:webauthn_credential_attestation] = {
      webauthn_id: webauthn_id,
      challenge: registration_options.challenge
    }

    if registration_options
      render status: :ok, json: registration_options
    else
      flash[:danger] = 'An error has occurred'
      render status: :unprocessable_entity, json: { message: "An error has occurred" }
    end


  end


  private

  def webauthn_id
    @webauthn_id ||= current_user&.webauthn_id&.webauthn_id || WebAuthn.generate_user_id
  end

  def create_params
    params.require(:webauthCredential).permit('type', 'id', 'rawId',
                                              { 'response' => %w[clientDataJSON attestationObject]},
                                              { 'clientExtensionResults' => {}})
  end

end
