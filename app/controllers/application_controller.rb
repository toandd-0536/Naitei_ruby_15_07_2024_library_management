class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale
  before_action :set_gon_variables
  before_action :store_user_location!, if: :storable_location?

  def encode_token payload
    JWT.encode(payload, ENV["JWT_SECRET_KEY"])
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(
        token, ENV["JWT_SECRET_KEY"],
        true,
        algorithm: Settings.algorithm
      )
    rescue JWT::DecodeError
      nil
    end
  end

  def after_sign_in_path_for resource
    stored_location_for resource || root_path
  end

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
    gon.img_type_error = I18n.t("message.episodes.img_type_error")
    gon.img_upload_error = I18n.t("message.episodes.img_upload_error")
  end

  def storable_location?
    request.get? && is_navigational_format? &&
      !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for :user, request.fullpath
  end
end
