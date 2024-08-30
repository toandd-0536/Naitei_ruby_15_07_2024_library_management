class Publisher < ApplicationRecord
  PUBLISHER_PARAMS = [:name].freeze

  has_many :books, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy

  validates :name, presence: true,
            length: {maximum: Settings.models.publisher.name.max_length}

  scope :sorted_by_name, ->{order(name: :asc)}
  scope :sorted_by_created, ->{order(created_at: :desc)}

  def self.ransackable_attributes _auth_object = nil
    %w(id name created_at updated_at)
  end
end
