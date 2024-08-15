class Publisher < ApplicationRecord
  PUBLISHER_PARAMS = [:name].freeze

  has_many :books, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy

  validates :name, presence: true,
            length: {maximum: Settings.models.publisher.name.max_length}
end
