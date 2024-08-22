class RatingsController < ApplicationController
  before_action :load_episode
  before_action :load_rating, only: :destroy

  def create
    @rating = @episode.ratings.new(rating_params.merge(user: current_user))
    if @rating.save
      handle_successful_save
    else
      handle_failed_save
    end
  end

  def handle_successful_save
    flash[:success] = t "message.ratings.created"
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("ratings_form",
                                                  partial: "ratings/my_review",
                                                  locals: {rating: @rating})
      end
    end
  end

  def handle_failed_save
    flash.now[:error] = t "message.ratings.create_fail"
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("ratings_form",
                                                  partial: "ratings/form",
                                                  locals: {episode: @episode,
                                                           rating: @rating}),
               status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @rating.user == current_user
      @rating.destroy
      flash[:success] = t "message.ratings.deleted"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("my_review",
                                 partial: "ratings/form",
                                 locals: {episode: @episode})
          ]
        end
        format.html{redirect_to @episode}
      end
    else
      flash[:error] = t "message.ratings.delete_fail"
    end
  end

  private

  def load_episode
    @episode = Episode.find_by id: params[:episode_id]
    return if @episode

    flash[:danger] = t "message.episodes.not_found"
    redirect_to root_url
  end

  def load_rating
    @rating = @episode.ratings.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "message.ratings.not_found"
    redirect_to root_url
  end

  def rating_params
    params.require(:rating).permit Rating::RATING_PARAMS
  end
end
