class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale
  before_action :set_gon_variables

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def render404
    render "errors/404", status: :not_found, layout: "404"
  end

  def handle_access_denied _exception
    flash[:danger] = t "message.access_denied"
    redirect_to root_path
  end

  def set_gon_variables
    gon.pusher_key = ENV["PUSHER_KEY"]
    gon.pusher_cluster = ENV["PUSHER_CLUSTER"]
    gon.user_id = current_user.id if user_signed_in?
  end
end
