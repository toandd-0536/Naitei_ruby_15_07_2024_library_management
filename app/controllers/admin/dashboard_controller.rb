class Admin::DashboardController < AdminController
  skip_load_and_authorize_resource
  authorize_resource class: false

  def index
    params.permit![:format]

    load_dashboard_counts
    load_category_data
    @borrow_books_by_category = borrow_books_by_category
    @categories_search = Category.all
    @authors_search = Author.all
    @publishers_search = Publisher.all
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true)
               .includes(:authors, :categories, :publisher, :episodes)

    respond_to do |format|
      format.html
      format.xlsx{render xlsx: "index", filename: "books_report.xlsx"}
    end
  end

  private

  def load_dashboard_counts
    @borrowing_books_count = BorrowBook.borrowing_books.count
    @overdue_books_count = BorrowBook.overdue_books.count
    @lost_books_count = BorrowBook.lost_books_in_current_month.count
    @pending_requests_count = BorrowBook.pending_requests.count
  end

  def load_category_data
    @categories = Category.top_level.includes(:books)
    @category_data = @categories.map do |category|
      {
        name: category.name,
        count: category.books.count
      }
    end
  end

  def borrow_books_by_category
    current_year = Date.current.year
    borrowed_books_data = BorrowBook.borrowed_books_data_by_month(current_year)

    categories = borrowed_books_data.keys.map(&:first).uniq
    categories.map do |category|
      monthly_counts = (1..12).map do |month|
        borrowed_books_data[[category, month]] || 0
      end
      {name: category, data: monthly_counts}
    end
  end
end
