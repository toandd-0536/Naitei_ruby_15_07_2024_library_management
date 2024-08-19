class Category < ApplicationRecord
  belongs_to :parent, class_name: Category.name, optional: true
  has_many :subcategories, class_name: Category.name,
            foreign_key: :parent_id, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :book_categories, dependent: :destroy
  has_many :books, through: :book_categories

  scope(:top_cat, lambda do |limit = Settings.models.category.top_count|
    joins(:books)
      .select("categories.*, COUNT(books.id) as books_count")
      .group("categories.id")
      .order("books_count DESC")
      .limit(limit)
  end)

  def cat_thumb
    episode = Episode.for_category(id).first
    episode&.thumb
  end
end
