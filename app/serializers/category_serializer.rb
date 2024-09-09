class CategorySerializer < ActiveModel::Serializer
  attributes %i(id name parent_id children_ids created_at updated_at)
  belongs_to :parent, serializer: CategorySerializer,
              if: ->{object.parent.present?}
  has_many :children, serializer: CategorySerializer
end
