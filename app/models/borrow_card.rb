class BorrowCard < ApplicationRecord
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  scope :recent_first, ->{order created_at: :desc}
end
