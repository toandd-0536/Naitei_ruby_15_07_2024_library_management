FactoryBot.define do
  factory :rating do
    rating {Faker::Number.between(from: 1, to: 5)}
    body {Faker::Lorem.sentence}
    association :episode
    association :user
  end
end
