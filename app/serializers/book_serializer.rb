class BookSerializer < ActiveModel::Serializer
  attributes %i(id name publisher_id created_at updated_at)
  belongs_to :publisher
  has_many :categories
  has_many :authors
end
