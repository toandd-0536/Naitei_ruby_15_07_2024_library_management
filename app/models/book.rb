class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :episodes, dependent: :destroy

  accepts_nested_attributes_for :authors, :episodes, allow_destroy: true
end
