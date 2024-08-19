class Episode < ApplicationRecord
  belongs_to :book
  has_many :carts, dependent: :destroy
  has_many :borrow_books, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :users, through: :carts

  scope(:trend_episodes, lambda do |limit = Settings.models.episode.trend_count|
    joins(:favorites)
      .where(favorites: {favoritable_type: "Episode"})
      .group("episodes.id")
      .order("COUNT(favorites.id) DESC")
      .limit(limit)
  end)

  scope(:most_reads, lambda do |limit = Settings.models.episode.most_count|
    joins(:ratings)
      .group("episodes.id")
      .select("episodes.*, COALESCE(AVG(ratings.rating), 0) as average_rating")
      .order("average_rating DESC")
      .limit(limit)
  end)

  scope(:for_category, lambda do |category_id|
    joins(book: :book_categories)
      .where(book_categories: {category_id:})
      .order(:id)
  end)

  def average_rating
    total_ratings = ratings.sum(:rating)
    total_count = ratings.count
    if total_count.positive?
      total_ratings.to_f / total_count
    else
      0
    end
  end
end
