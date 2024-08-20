class EpisodesController < ApplicationController
  before_action :set_book, :set_episode, only: %i(show add_to_cart)
  before_action :redirect_unless_signed_in,
                :validate_conditions, only: :add_to_cart
  def show; end

  def all
    @episodes_search = Episode.search search_params
    @pagy, @episodes = pagy @episodes_search,
                            limit: Settings.controllers.episodes.all.per_page
  end

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
    @ratings = @episode.ratings.recent.where.not(user: current_user)
    @user_rating = @episode.ratings.find_by(user: current_user)
  end

  def validate_conditions
    return if current_user.can_borrow_episode? @episode

    flash[:error] = current_user.errors.full_messages
    redirect_back(fallback_location: root_path)
  end

  def search_params
    params.permit Episode::SEARCH_PARAMS
  end
end
