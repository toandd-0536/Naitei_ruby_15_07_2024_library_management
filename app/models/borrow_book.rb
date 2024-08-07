class BorrowBook < ApplicationRecord
  belongs_to :borrow_card
  belongs_to :episode

  enum status: {in_cart: 0,
                pending: 1,
                cancel: 2,
                confirm: 3,
                paid: 4,
                overdue: 5,
                lost: 6}
end
