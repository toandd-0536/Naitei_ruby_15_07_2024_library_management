class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  scope :favorite_books, lambda {|limit = nil|
    favorites = where(favoritable_type: "Episode").includes(:favoritable)
    favorites = favorites.limit(limit) if limit
    favorites.map(&:favoritable)
  }

  scope :favorite_authors, lambda {|limit = nil|
    favorites = where(favoritable_type: "Author").includes(:favoritable)
    favorites = favorites.limit(limit) if limit
    favorites.map(&:favoritable)
  }
end
