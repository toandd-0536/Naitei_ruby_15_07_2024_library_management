class BorrowBookMailer < ApplicationMailer
  def status_change borrow_book, old_status, new_status
    @borrow_book = borrow_book
    @user = borrow_book.borrow_card.user
    @old_status = old_status
    @new_status = new_status
    @status = borrow_book.localized_status
    @book = borrow_book.episode.book
    @episode = borrow_book.episode
    @due_date = borrow_book.due_date

    mail to: @user.email, subject: subject_for_status_change
  end

  private

  def subject_for_status_change
    I18n.t("borrow_book_mailer.status_change.subject.#{@new_status}")
  end
end
