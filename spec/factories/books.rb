FactoryBot.define do
  factory :book do
    name {Faker::Book.title}
    association :publisher

    trait :with_authors_and_categories do
      transient do
        authors_count {1}
        categories_count { 1 }
      end

      before(:create) do |book, evaluator|
        book.authors = create_list(:author, evaluator.authors_count)
        book.categories = create_list(:category, evaluator.categories_count)
      end
    end
  end
end
