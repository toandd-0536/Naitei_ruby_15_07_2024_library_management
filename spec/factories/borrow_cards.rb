FactoryBot.define do
  factory :borrow_card do
    association :user
    start_time {Date.today}
  end
end
