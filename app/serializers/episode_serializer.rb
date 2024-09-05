class EpisodeSerializer < ActiveModel::Serializer
  attributes %i(id name book_id created_at updated_at)
  belongs_to :book
end
