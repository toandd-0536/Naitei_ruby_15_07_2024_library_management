class NotificationsController < ApplicationController
  before_action :redirect_unless_signed_in
  before_action :set_notify, only: %i(destroy update_status)

  def index
    @notifications = current_user.notifications
  end

  def destroy
    if @notification.destroy
      flash[:success] = t "controllers.notifications.destroy_success"
    else
      flash[:error] = t "controllers.notifications.destroy_error"
    end
    redirect_back(fallback_location: notifications_path)
  end

  def update_status
    if @notification.update status: Settings.readed_status
      flash[:success] = t "controllers.notifications.update_success"
    else
      flash[:error] = t "controllers.notifications.update_error"
    end
    redirect_back(fallback_location: notifications_path)
  end

  private
  def set_notify
    @notification = Notification.find_by id: params[:id]
  end
end
