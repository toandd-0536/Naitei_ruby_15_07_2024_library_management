class SessionsController < ApplicationController
  layout Settings.controllers.sessions.layout
  before_action :check_signed_in?, only: %i(create new)

  def new
    @user = User.new
  end

  def create
    @user = User.new session_params
    user = User.find_by email: params.dig(:user, :email)&.downcase
    if user.try :authenticate, params.dig(:user, :password)
      log_in user
      redirect_to root_path
    else
      @user.valid?
      @user.errors.add :base, t("controllers.sessions.error_login")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete :user_id
    flash[:success] = t "controllers.sessions.logout_success"
    redirect_to login_path
  end

  private
  def session_params
    params.require(:user).permit(:email, :password)
  end

  def check_signed_in?
    return unless user_signed_in?

    redirect_back(fallback_location: root_path)
  end
end
