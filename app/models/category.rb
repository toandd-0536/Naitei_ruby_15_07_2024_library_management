class Category < ApplicationRecord
  CATEGORY_PARAMS = %i(name parent_id).freeze

  belongs_to :parent, class_name: Category.name, optional: true
  has_many :children, class_name: Category.name,
           foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :book_categories, dependent: :destroy
  has_many :books, through: :book_categories

  validates :name, presence: true
  validate :parent_id_cannot_be_self
  validate :parent_id_cannot_be_child

  scope :sorted_by_name, ->{order(name: :asc)}
  scope :sorted_by_created, ->{order(created_at: :desc)}
  scope(:top_cat, lambda do |limit = Settings.models.category.top_count|
    joins(:books)
      .select("categories.*, COUNT(books.id) as books_count")
      .group("categories.id")
      .order("books_count DESC")
      .limit(limit)
  end)
  scope :top_level, ->{where(parent_id: nil)}

  def self.ransackable_attributes _auth_object = nil
    %w(created_at id name parent_id updated_at)
  end

  def cat_thumb
    episode = Episode.for_category(id).first
    episode&.thumb
  end

  def children_ids
    children.pluck(:id)
  end

  private
  def parent_id_cannot_be_self
    return unless parent_id.present? && parent_id == id

    message = I18n.t("message.categories.duplicate")
    errors.add(:parent_id, :invalid, message:)
  end

  def parent_id_cannot_be_child
    return unless parent_id.present? && children_ids.include?(parent_id)

    message = I18n.t("message.categories.child_error")
    errors.add(:parent_id, :invalid, message:)
  end
end
