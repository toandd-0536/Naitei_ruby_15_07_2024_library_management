class HomeController < ApplicationController
  def index
    @trend_books = Episode.trend_episodes
    @most_reads = Episode.most_reads
    @top_cats = Category.top_cat
  end

  def search_ajax
    search = params[:search]
    @episodes = search.present? ? Episode.search_by_name(search) : []

    respond_to do |format|
      format.html
      format.js
    end
  end
end
