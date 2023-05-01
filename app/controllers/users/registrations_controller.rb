# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_session_for_all_types, only: [:create]
  
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  before_action :track_path_visit

  def update_resource(resource, params)
    if resource.provider == "google_oauth2"
      params.delete("current_password")
      resource.password = params["password"]
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  # GET /resource/sign_up
  def new
    super
  end

  #POST /resource
  def create
    super
    if @current_guest
      resource.brainstorms << @current_guest.brainstorms
      resource.update(name: @current_guest.name)
    end
  end

  def select_sign_up_method
  end

  def sign_up_with_google
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :privacy_policy_agreement])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # The path used after sign up.
  def after_inactive_sign_up_path_for(resource)
    stored_location_for(resource) || new_brainstorm_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
