class UsersController < ApplicationController
  layout "login_layout", only: %i(new create)

  def show; end

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

  private
  def user_params
    params.require(:user).permit User::CREATE_PARAMS
  end
end
