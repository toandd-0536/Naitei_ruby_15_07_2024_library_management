class ErrorsController < ApplicationController
  def render404
    render "errors/404", status: :not_found, layout: "404"
  end
end
