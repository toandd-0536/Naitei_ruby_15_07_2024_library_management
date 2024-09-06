class BorrowBookMailer < ApplicationMailer
  helper Admin::BorrowBookMailerHelper

  def status_change borrow_book, old_status, new_status
    @borrow_book = borrow_book
    @user = borrow_book.borrow_card.user
    @old_status = old_status
    @new_status = new_status
    @status = borrow_book.localized_status
    @book = borrow_book.episode.book
    @episode = borrow_book.episode
    @due_date = borrow_book.borrow_card.due_date

    mail to: @user.email, subject: subject_for_status_change
  end

  def reminder_email borrow_card
    @borrow_card = borrow_card
    @borrow_books = borrow_card.borrow_books
    @user = borrow_card.user
    @due_date = borrow_card.due_date

    mail to: @user.email,
         subject: I18n.t("borrow_book_mailer.reminder_email.subject")
  end

  def self.enqueue_status_change borrow_book, old_status, new_status
    BorrowBookMailerJob.perform_later borrow_book, old_status, new_status
  end

  private

  def subject_for_status_change
    I18n.t("borrow_book_mailer.status_change.subject.#{@new_status}")
  end
end
