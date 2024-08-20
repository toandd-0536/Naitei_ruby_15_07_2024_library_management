class Rating < ApplicationRecord
  RATING_PARAMS = [:body, :rating].freeze

  belongs_to :episode
  belongs_to :user

  scope :recent, ->{order(created_at: :desc)}
end
