class EpisodesController < ApplicationController
  before_action :authenticated?, only: :add_to_cart
  before_action :set_book, only: %i(show add_to_cart)
  before_action :set_episode, only: %i(show add_to_cart)
  before_action :validate_conditions, only: :add_to_cart

  def show; end

  def add_to_cart
    @episode = Episode.find params[:id]
    cart_item = current_user.carts.create episode: @episode
    if cart_item.persisted?
      flash[:success] = t "controllers.episodes.success"
    else
      flash[:error] = t "controllers.episodes.error_save"
    end
    redirect_back(fallback_location: book_episode_path(@book, @episode))
  end

  private
  def set_book
    @book = Book.find params[:book_id]
  end

  def set_episode
    @episode = @book.episodes.find params[:id]
  end

  def authenticated?
    return if user_signed_in?

    flash[:error] = t "controllers.episodes.error_login"
    redirect_back(fallback_location: root_path) and return
  end

  def validate_conditions
    if !current_user.activated
      redirect_with_error "controllers.episodes.error_active"
    elsif current_user.blacklisted
      redirect_with_error "controllers.episodes.error_blacklist"
    elsif current_user.carts.exists? episode: @episode
      redirect_with_error "controllers.episodes.error_exists"
    elsif @episode.qty < 1
      redirect_with_error "controllers.episodes.error_qty"
    elsif current_user.currently_borrowing_episodes_count >= Settings.max_book
      redirect_with_error "controllers.episodes.error_max"
    end
  end

  def redirect_with_error error_key
    flash[:error] = t error_key
    redirect_back(fallback_location: root_path) and return
  end
end
