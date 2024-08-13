module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def check_not_signed_in?
    return if user_signed_in?

    flash[:error] = t "controllers.users.check_not_signed_in"
    redirect_to login_path
  end

  def check_signed_in?
    return if user_signed_in?

    redirect_back(fallback_location: root_path)
  end
end
