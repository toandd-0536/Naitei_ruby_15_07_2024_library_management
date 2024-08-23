class UsersController < ApplicationController
  layout "login_layout", only: %i(new create)
  before_action :check_not_signed_in?, only: %i(new create)
  before_action :redirect_unless_signed_in, only: %i(show update)

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    generated_pass = User.generate_random_password
    @user.password = generated_pass
    if @user.save
      UserMailer.welcome_mail(@user, generated_pass).deliver_now
      flash[:success] = t "controllers.users.success"
      redirect_to login_path
    else
      flash.now[:error] = t "controllers.users.register_error"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    if @user.update user_update_params
      flash[:success] = t "controllers.users.update_success"
      redirect_back(fallback_location: root_path)
    else
      flash.now[:error] = t "controllers.users.update_error"
      render :show, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::CREATE_PARAMS
  end

  def user_update_params
    params.require(:user).permit User::UPDATE_PARAMS
  end
end
