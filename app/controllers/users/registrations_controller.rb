class Users::RegistrationsController < Devise::RegistrationsController
  layout "login_layout"
  before_action :configure_sign_up_params, only: :create

  def create
    super do |resource|
      UserMailer.welcome_mail(resource).deliver_now if resource.persisted?
    end
  end

  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
  end
end
