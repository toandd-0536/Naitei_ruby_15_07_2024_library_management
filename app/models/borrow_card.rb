class BorrowCard < ApplicationRecord
  belongs_to :user
  has_many :borrow_books, dependent: :destroy
end
