class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if Setting.find_or_initialize_by(key: 'allow_registrations').value != "1"
      redirect_to "/users/sign_in", flash: {error: "New sign ups are not allowed."}
    else
      super
    end
  end

  # POST /resource
  def create
    if Setting.find_or_initialize_by(key: 'allow_registrations').value != "1"
      redirect_to "/users/sign_in", flash: {error: "New sign ups are not allowed."}
    else
      super
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    super
    user = User::find_by_email(params[:user][:email])
    user.first_name = params[:user][:first_name]
    user.last_name = params[:user][:last_name]
    user.save!
  end

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

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
