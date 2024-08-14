class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private
  def render404
    render "errors/404", status: :not_found, layout: "404"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
