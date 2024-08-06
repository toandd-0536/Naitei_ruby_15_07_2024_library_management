class Episode < ApplicationRecord
  belongs_to :book
  has_many :borrow_books, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
