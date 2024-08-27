class Admin::BorrowBooksController < AdminController
  before_action :load_borrow_book, except: %i(borrow return history refresh)

  def borrow
    @borrow_books = BorrowBook.pending.includes(borrow_card: :user)
                              .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [{name: t(".borrow.title")}]
  end

  def return
    @borrow_books = BorrowBook.confirm.or(BorrowBook.overdue)
                              .includes(borrow_card: :user)
                              .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [{name: t(".return.title")}]
  end

  def history
    @borrow_books = BorrowBook.cancel.or(BorrowBook.returned)
                              .or(BorrowBook.lost)
                              .includes(borrow_card: :user)
                              .by_updated_desc
    @pagy, @borrow_books = pagy(@borrow_books, items: Settings.page)
    @breadcrumb_items = [{name: t(".history.title")}]
  end

  def show
    case @borrow_book.status
    when "pending"
      breadcrumb_name = t ".borrow.title"
      breadcrumb_url = borrow_admin_borrow_books_path
    when "confirm", "overdue"
      breadcrumb_name = t ".return.title"
      breadcrumb_url = return_admin_borrow_books_path
    else
      breadcrumb_name = t ".history.title"
      breadcrumb_url = history_admin_borrow_books_path
    end
    @breadcrumb_items = [
      {name: breadcrumb_name, url: breadcrumb_url},
      {name: @borrow_book.id}
    ]
  end

  def confirm
    episode = @borrow_book.episode
    if episode.qty.positive? && episode.decrement!(:qty)
      if @borrow_book.confirm!
        send_status_change_email @borrow_book, "confirm"
        flash[:success] = t "message.borrow_books.confirmed"
      else
        episode.increment! :qty
        flash[:danger] = t "message.borrow_books.status_fail"
      end
    else
      flash[:danger] = t "message.borrow_books.qty_insufficient"
    end
    redirect_to borrow_admin_borrow_books_path
  end

  def cancel
    if @borrow_book.update status: :cancel,
                           reason: params[:borrow_book][:reason]
      send_status_change_email @borrow_book, "cancel"
      flash[:success] = t "message.borrow_books.canceled"
    else
      flash[:danger] = t "message.borrow_books.status_fail"
    end
    redirect_to borrow_admin_borrow_books_path
  end

  def returned
    episode = @borrow_book.episode
    if episode.increment!(:qty) && @borrow_book.update(status: :returned)
      activate_overdue_user
      send_status_change_email @borrow_book, "returned"
      flash[:success] = t "message.borrow_books.returned"
    else
      flash[:error] = t "message.borrow_books.status_fail"
    end
    redirect_to return_admin_borrow_books_path
  end

  def lost
    user = @borrow_book.borrow_card.user

    if @borrow_book.lost!
      user.update lost_time: user.lost_time + 1, activated: false
      send_status_change_email @borrow_book, "lost"
      flash[:success] = t "message.borrow_books.lost"
    else
      flash[:error] = t "message.borrow_books.status_fail"
    end

    redirect_to return_admin_borrow_books_path
  end

  def refresh
    overdue_borrow_books = BorrowBook.confirm.select do |borrow_book|
      borrow_book.due_date < Time.current
    end

    overdue_borrow_books.each do |borrow_book|
      if borrow_book.overdue!
        borrow_book.borrow_card.user.update activated: false
        send_status_change_email borrow_book, "overdue"
      else
        flash[:error] = t "message.borrow_books.status_fail"
      end
    end

    flash[:success] = t "message.borrow_books.refresh_success"
    redirect_to return_admin_borrow_books_path
  end

  private

  def load_borrow_book
    @borrow_book = BorrowBook.find_by id: params[:id]
    return if @borrow_book

    flash[:danger] = t "message.borrow_books.not_found"
    redirect_to admin_borrow_books_path
  end

  def activate_overdue_user
    return unless @borrow_book.status_before_last_save.to_sym == :overdue

    @borrow_book.borrow_card.user.update activated: true
  end

  def send_status_change_email borrow_book, new_status
    BorrowBookMailer.status_change(
      borrow_book,
      borrow_book.status_before_last_save,
      new_status
    ).deliver!
  end
end
