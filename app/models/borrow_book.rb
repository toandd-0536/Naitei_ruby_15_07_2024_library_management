class BorrowBook < ApplicationRecord
  belongs_to :borrow_card
  belongs_to :episode

  enum status: {pending: 0,
                cancel: 1,
                confirm: 2,
                returned: 3,
                overdue: 4,
                lost: 5}

  def localized_status
    I18n.t("activerecord.attributes.borrow_book.status.#{status}")
  end

  scope(:by_user, lambda do |user_id|
    joins(:borrow_card)
      .where(borrow_cards: {user_id:})
  end)
  scope :active, ->{where.not(status: Settings.add_book_not_status)}
  scope :by_updated_desc, ->{order(updated_at: :desc)}
  scope :borrowing_books, ->{where(status: %w(confirm overdue))}
  scope :overdue_books, ->{where(status: "overdue")}
  scope(:lost_books_in_current_month, lambda do
    where(
      status: "lost",
      updated_at: Time.current.beginning_of_month..Time.current.end_of_month
    )
  end)
  scope :pending_requests, ->{where(status: "pending")}

  scope(:borrowed_books_data_by_month, lambda do |year|
    joins(episode: {book: :categories})
      .joins("INNER JOIN borrow_cards ON
              borrow_books.borrow_card_id = borrow_cards.id")
      .where(categories: {parent_id: nil})
      .where("YEAR(borrow_cards.start_time) = ?", year)
      .group("categories.name", "MONTH(borrow_cards.start_time)")
      .count
  end)
end
