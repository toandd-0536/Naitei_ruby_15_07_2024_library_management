class BorrowCard < ApplicationRecord
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  def due_date
    start_time + Settings.models.book_borrow.max_borrow_duration
  end

  scope :recent_first, ->{order created_at: :desc}
  scope :by_updated_desc, ->{order(updated_at: :desc)}
  scope(:due_tomorrow, lambda do
    where("borrow_cards.start_time + INTERVAL ? DAY = ?",
          Settings.models.book_borrow.max_borrow_duration,
          Date.tomorrow)
  end)

  def self.ransackable_attributes _auth_object = nil
    %w(created_at id start_time updated_at user_id)
  end

  def self.ransackable_associations _auth_object = nil
    %w(borrow_books user)
  end
end
