class BorrowBookMailerJob < ApplicationJob
  queue_as :default

  def perform borrow_book, old_status, new_status
    BorrowBookMailer.status_change(borrow_book, old_status,
                                   new_status).deliver_now
  end
end
