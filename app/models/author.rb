class Author < ApplicationRecord
  AUTHOR_PARAMS = %i(name intro bio dob dod thumb_img).freeze

  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :episodes, through: :books
  has_one_attached :thumb_img

  validates :name, presence: true,
            length: {maximum: Settings.models.author.name.max_length}
  validates :intro, presence: true,
            length: {maximum: Settings.models.author.intro.max_length}
  validates :bio, presence: true
  validates :dob, presence: true
  validate :date_of_death_not_before_date_of_birth

  scope :sorted_by_name, ->{order(name: :asc)}
  scope :sorted_by_created, ->{order(created_at: :desc)}

  def self.ransackable_attributes _auth_object = nil
    %w(bio created_at dob dod id intro name thumb thumb_img updated_at)
  end

  def self.ransackable_associations _auth_object = nil
    %w(book_authors books episodes favorites)
  end

  private

  def date_of_death_not_before_date_of_birth
    return if dod.blank? || dob.blank?

    return unless dod < dob

    errors.add(:dod, :after_date_of_birth)
  end
end
