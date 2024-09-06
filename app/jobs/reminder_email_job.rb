require "sidekiq-scheduler"

class ReminderEmailJob < ApplicationJob
  queue_as :default

  def perform
    borrow_cards =
      BorrowCard.joins(:borrow_books)
                .due_tomorrow
                .distinct

    borrow_cards.each do |borrow_card|
      BorrowBookMailer.reminder_email(borrow_card).deliver_now
    end
  end
end
