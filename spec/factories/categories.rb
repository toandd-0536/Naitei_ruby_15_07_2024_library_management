FactoryBot.define do
  factory :category do
    name {Faker::Book.genre}
    parent_id {nil}
  end
end
