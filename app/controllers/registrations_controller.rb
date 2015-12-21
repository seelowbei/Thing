class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, only: [:new, :create]
	before_filter :configure_permitted_parameters

  def new
    if current_user && current_user.is_superadmin?
      super
    else
      redirect_to root_path
    end
  end

  def create
    if current_user.is_superadmin?
      message = ""
      message = "Email is blank. " if email.blank?
      message += "Password is blank. " if password.blank?
      message += "Password Confirmation is blank. " if password_confirmation.blank?

      if email.presence && role.presence && password.presence && password_confirmation.presence
        if password != password_confirmation
          redirect_to new_user_registration_path, flash: { error: "Password and Password Confirmation mismatch!" }
        else
          @user = User.new(user_params)
          begin
            @user.save
            redirect_to users_path, notice: 'User is successfully created.'
          rescue
            redirect_to new_user_registration_path, flash: { error: "USER NOT CREATED as email already taken!" }
          end
        end
      else
        redirect_to new_user_registration_path, flash: { error: message+= "USER NOT CREATED!" }
      end
    else
      redirect_to root_path
    end
  end

   protected
   def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :role)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :role, :current_password)
    end
  end

  def user_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def email
    user_params[:email]
  end

  def role
    user_params[:role]
  end

  def password
    user_params[:password]
  end

  def password_confirmation
    user_params[:password_confirmation]
  end

  def after_update_path_for(resource)
    if current_user.role == 'admin'
      users_path
    else
      report_questions_path
    end
  end
end
