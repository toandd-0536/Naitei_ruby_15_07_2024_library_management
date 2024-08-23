module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def current_user? user
    user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def user_signed_in?
    !!current_user
  end

  def redirect_unless_signed_in
    return if user_signed_in?

    flash[:error] = t "controllers.episodes.error_login"
    redirect_back(fallback_location: root_path)
  end

  def check_not_signed_in?
    return unless user_signed_in?

    redirect_back(fallback_location: root_path)
  end
end
