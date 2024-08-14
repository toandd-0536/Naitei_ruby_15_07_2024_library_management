class BorrowBook < ApplicationRecord
  belongs_to :borrow_card
  belongs_to :episode

  enum status: {pending: 0,
                cancel: 1,
                confirm: 2,
                returned: 3,
                overdue: 4,
                lost: 5}

  scope(:by_user, lambda do |user_id|
    joins(:borrow_card)
      .where(borrow_cards: user_id)
  end)
  scope :active, ->{where.not(status: Settings.add_book_not_status)}
end
