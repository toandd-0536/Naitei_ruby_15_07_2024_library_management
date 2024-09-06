class AuthorSerializer < ActiveModel::Serializer
  attributes %i(id name intro bio dob dod created_at updated_at)
end
