class HomeController < ApplicationController
  def index
    @trend_books = Episode.trend_episodes
    @most_reads = Episode.most_reads
    @top_cats = Category.top_cat
  end
end
