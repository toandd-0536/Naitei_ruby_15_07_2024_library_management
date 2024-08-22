class Admin::BooksController < AdminController
  before_action :load_book, only: %i(show edit update destroy)
  before_action :load_foreign_values, except: %i(index show)

  def index
    @pagy, @books = pagy Book.sorted_by_created, items: Settings.page
    @breadcrumb_items = [{name: t(".index.title")}]
  end

  def show
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_books_path},
      {name: @book.name}
    ]
  end

  def new
    @book = Book.new
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_books_path},
      {name: t(".new.title")}
    ]
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:success] = t "message.books.created"
      redirect_to admin_books_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_books_path},
      {name: @book.name, url: admin_book_path(@book)},
      {name: t(".edit.title")}
    ]
  end

  def update
    if @book.update book_params
      flash[:success] = t "message.books.updated"
      redirect_to admin_book_path(@book)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = t "message.books.deleted"
    else
      flash[:danger] = t "message.books.delete_fail"
    end
    redirect_to admin_books_path
  end

  private
  def book_params
    params.require(:book).permit Book::BOOK_PARAMS
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = t "message.books.not_found"
    redirect_to root_url
  end

  def load_foreign_values
    @cats = Category.sorted_by_name
    @publishers = Publisher.sorted_by_name
    @authors = Author.sorted_by_name
  end
end
