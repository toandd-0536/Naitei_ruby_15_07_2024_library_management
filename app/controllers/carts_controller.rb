class CartsController < ApplicationController
  before_action :redirect_unless_signed_in
  def index
    @carts = current_user.carts
  end

  def destroy
    cart_item = current_user.carts.find params[:id]
    if cart_item.destroy
      flash[:success] = t "controllers.carts.delete_success"
    else
      flash[:error] = t "controllers.carts.delete_error"
    end
    redirect_back(fallback_location: carts_path)
  end

  def delete_all
    carts = current_user.carts
    if carts.destroy_all
      flash[:success] = t "controllers.carts.delete_all_success"
    else
      flash[:error] = t "controllers.carts.delete_all_error"
    end
    redirect_back(fallback_location: carts_path)
  end
end
