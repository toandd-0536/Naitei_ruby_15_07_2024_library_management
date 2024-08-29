class AdminController < ApplicationController
  before_action :logged_in_user
  before_action :authorize_admin!

  load_and_authorize_resource

  layout "admin"

  helper Admin::ApplicationHelper

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "message.auth.login"
    redirect_to new_user_session_url
  end

  def authorize_admin!
    authorize! :manage, :all
  end
end
