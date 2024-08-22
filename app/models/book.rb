class Book < ApplicationRecord
  BOOK_PARAMS = %i(
    name
    publisher_id
  ).freeze + [
    {category_ids: [], author_ids: []}
  ].freeze

  belongs_to :publisher
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :episodes, dependent: :destroy
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories

  accepts_nested_attributes_for :authors, :episodes, :categories,
                                allow_destroy: true

  validates :name, presence: true
  validates :publisher_id, presence: true
  validate :must_have_categories
  validate :must_have_authors

  scope :sorted_by_name, ->{order(name: :asc)}
  scope :sorted_by_created, ->{order(created_at: :desc)}

  private
  def must_have_categories
    return unless categories.empty?

    errors.add(:categories, I18n.t("message.books.cat_found"))
  end

  def must_have_authors
    return unless authors.empty?

    errors.add(:authors, I18n.t("message.books.book_found"))
  end
end
