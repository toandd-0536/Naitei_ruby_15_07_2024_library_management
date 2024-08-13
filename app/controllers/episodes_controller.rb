class EpisodesController < ApplicationController
  before_action :set_book, only: :show
  before_action :set_episode, only: :show

  def show; end

  private
  def set_book
    @book = Book.find params[:book_id]
  end

  def set_episode
    @episode = @book.episodes.find params[:id]
  end
end
