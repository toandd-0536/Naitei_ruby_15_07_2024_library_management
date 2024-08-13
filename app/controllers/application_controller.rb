class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  include SessionsHelper
  include Pagy::Backend

  private
  def render404
    render "errors/404", status: :not_found, layout: "404"
  end
end
