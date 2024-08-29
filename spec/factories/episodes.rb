FactoryBot.define do
  factory :episode do
    name {Faker::Book.title}
    qty {Faker::Number.between(from: 1, to: 10)}
    intro {Faker::Lorem.sentence}
    content {Faker::Lorem.paragraph}
    compensation_fee {Faker::Number.between(from: 100, to: 1000)}
    thumb {Faker::Avatar.image}
    association :book
  end
end
