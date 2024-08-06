class Rating < ApplicationRecord
  belongs_to :episode
  belongs_to :user
end
