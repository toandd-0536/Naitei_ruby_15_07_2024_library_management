FactoryBot.define do
  factory :borrow_book do
    association :borrow_card
    association :episode
    status {:pending}
    reason {"User requested the episode"}
  end
end
