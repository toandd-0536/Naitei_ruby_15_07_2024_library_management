class UsersController < ApplicationController
  before_action :redirect_unless_signed_in

  def show
    @user = current_user
  end

  def update
    @user = current_user
    clean_password_params_if_blank

    if @user.update user_update_params
      bypass_sign_in @user
      flash[:success] = t "controllers.users.update_success"
      redirect_back(fallback_location: root_path)
    else
      flash.now[:error] = t "controllers.users.update_error"
      render :show, status: :unprocessable_entity
    end
  end

  private
  def clean_password_params_if_blank
    return if params[:user][:password].present?

    params[:user].delete :password
    params[:user].delete :password_confirmation
  end

  def user_update_params
    params.require(:user).permit User::UPDATE_PARAMS
  end
end
