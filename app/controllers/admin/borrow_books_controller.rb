class Admin::BorrowBooksController < AdminController
  before_action :load_borrow_book, only: %i(show edit update destroy)

  def borrow
    @pagy, @borrow_books = pagy BorrowBook.pending.includes(borrow_card: :user),
                                items: Settings.page
    @breadcrumb_items = [{name: t(".borrow.title")}]
  end

  def return
    @pagy, @borrow_books = pagy BorrowBook.confirm.or(BorrowBook.overdue)
                                          .includes(borrow_card: :user),
                                items: Settings.page
    @breadcrumb_items = [{name: t(".return.title")}]
  end

  def history
    @pagy, @borrow_books = pagy BorrowBook.cancel.or(BorrowBook.returned)
                                          .or(BorrowBook.lost)
                                          .includes(borrow_card: :user),
                                items: Settings.page
    @breadcrumb_items = [{name: t(".history.title")}]
  end

  def show
    case @borrow_book.status
    when "pending"
      breadcrumb_name = t(".borrow.title")
      breadcrumb_url = borrow_admin_borrow_books_path
    when "confirm", "overdue"
      breadcrumb_name = t(".return.title")
      breadcrumb_url = return_admin_borrow_books_path
    else
      breadcrumb_name = t(".history.title")
      breadcrumb_url = history_admin_borrow_books_path
    end
    @breadcrumb_items = [
      {name: breadcrumb_name, url: breadcrumb_url},
      {name: @borrow_book.id}
    ]
  end

  def new
    @borrow_book = BorrowBook.new
    @breadcrumb_items = [
      {name: t(".borrow.title"),
       url: borrow_admin_borrow_books},
      {name: t(".new.title")}
    ]
  end

  def create
    @borrow_book = BorrowBook.new(borrow_book_params)
    if @borrow_book.save
      flash[:success] = t "message.borrow_books.new"
      redirect_to admin_borrow_book_path(@borrow_book), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @breadcrumb_items = [
      {name: t(".borrow.title"), url: admin_borrow_books_path},
      {name: @borrow_book.id, url: admin_borrow_book_path(@borrow_book)},
      {name: t(".edit.title")}
    ]
  end

  def update
    if @borrow_book.update(borrow_book_params)
      flash[:success] = t "message.borrow_books.updated"
      redirect_to admin_borrow_book_path(@borrow_book)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @borrow_book.destroy
      flash[:success] = t "message.borrow_books.deleted"
    else
      flash[:danger] = t "message.borrow_books.delete_fail"
    end
    redirect_to borrow_admin_borrow_books
  end

  private

  def load_borrow_book
    @borrow_book = BorrowBook.find(params[:id])
    return if @borrow_book

    flash[:danger] = t "message.borrow_books.not_found"
    redirect_to admin_borrow_books_path
  end
end
