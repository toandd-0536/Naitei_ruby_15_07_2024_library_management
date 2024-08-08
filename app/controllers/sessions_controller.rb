class SessionsController < ApplicationController
  layout Settings.controllers.sessions.layout
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

  private
  def session_params
    params.require(:user).permit(:email, :password)
  end
end
