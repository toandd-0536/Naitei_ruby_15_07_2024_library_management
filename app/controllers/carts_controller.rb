class CartsController < ApplicationController
  before_action :redirect_unless_signed_in
  before_action :validate_conditions, only: :checkout
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

  def checkout
    user = current_user
    cart_items = fetch_cart_items user

    if cart_items.empty?
      handle_empty_cart
    else
      process_checkout user, cart_items
    end
  end

  private

  def fetch_cart_items user
    user.carts.includes :episode
  end

  def handle_empty_cart
    flash[:error] = t "controllers.carts.empty_error"
    redirect_back(fallback_location: carts_path)
  end

  def process_checkout user, cart_items
    ActiveRecord::Base.transaction do
      borrow_card = create_borrow_card user
      borrow_books = build_borrow_books borrow_card, cart_items
      BorrowBook.insert_all! borrow_books
      clear_cart cart_items
      OrderMailer.order_mail(user, borrow_card).deliver_now
      flash[:success] = t "controllers.carts.checkout_success"
    rescue ActiveRecord::RecordInvalid
      flash[:error] = t "controllers.carts.checkout_error"
    end

    redirect_back(fallback_location: carts_path)
  end

  def create_borrow_card user
    BorrowCard.create!(
      user:,
      start_time: Time.zone.today
    )
  end

  def build_borrow_books borrow_card, cart_items
    cart_items.map do |item|
      {
        borrow_card_id: borrow_card.id,
        episode_id: item.episode_id,
        status: Settings.cart_item_default_status,
        created_at: Time.current,
        updated_at: Time.current
      }
    end
  end

  def clear_cart cart_items
    cart_items.destroy_all
  end

  def validate_conditions
    return if current_user.can_checkout_cart?

    flash[:error] = current_user.errors.full_messages
    redirect_back(fallback_location: root_path)
  end
end
