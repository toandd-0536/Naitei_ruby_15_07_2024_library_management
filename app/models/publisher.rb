class Publisher < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
end
