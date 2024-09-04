class BorrowCard < ApplicationRecord
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  def due_date
    start_time + Settings.models.book_borrow.max_borrow_duration
  end

  scope :recent_first, ->{order created_at: :desc}
end
