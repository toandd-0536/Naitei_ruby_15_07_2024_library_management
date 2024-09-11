class FavoritesController < ApplicationController
  before_action :redirect_unless_signed_in
  def index
    @favorite_books = current_user
                      .favorites
                      .favorite_books(Settings.models.episode.limit)
    @favorite_authors = current_user
                        .favorites
                        .favorite_authors(Settings.models.author.limit)
  end

  def books
    @favorite_books = current_user.favorites.favorite_books
  end

  def authors
    @favorite_authors = current_user.favorites.favorite_authors
  end

  def create
    @favoritable = find_favoritable
    favorite = @favoritable.favorites.new(user: current_user)

    if favorite.save
      flash[:success] = t "message.favorites.created"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.turbo_stream
      end
    else
      flash[:error] = t "message.favorites.create_fail"
    end
  end

  def destroy
    @favoritable = find_favoritable
    favorite = @favoritable.favorites.find_by(user: current_user)

    if favorite.destroy
      flash[:success] = t "message.favorites.deleted"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.turbo_stream
      end
    else
      flash[:error] = t "message.favorites.delete_fail"
    end
  end

  private

  def find_favoritable
    params[:favoritable_type].constantize.find(params[:favoritable_id])
  end
end
