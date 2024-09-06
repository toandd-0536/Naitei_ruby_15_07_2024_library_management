class Api::V1::Admin::BooksController < AdminController
  before_action :load_book, only: %i(show update destroy)
  before_action :load_foreign_values, except: %i(index show)

  def index
    @pagy, @books = pagy Book.sorted_by_created, items: Settings.page
    render json: {
      books: serialized_books,
      pagy: @pagy
    }, status: :ok
  end

  def show
    render json: BookSerializer.new(@book).as_json, status: :ok
  end

  def create
    @book = Book.new book_params
    if @book.save
      token = encode_token book_id: @book.id
      render json: {
        message: t("message.books.created"),
        book: BookSerializer.new(@book).as_json,
        token:
      }, status: :created
    else
      render json: {errors: @book.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    token = encode_token book_id: @book.id
    if @book.update book_params
      render json: {
        message: t("message.books.updated"),
        book: BookSerializer.new(@book).as_json,
        token:
      }, status: :ok
    else
      render json: {errors: @book.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      render json: {message: t("message.books.deleted")}, status: :ok
    else
      render json: {message: t("message.books.delete_fail")},
             status: :unprocessable_entity
    end
  end

  private
  def book_params
    params.require(:book).permit Book::BOOK_PARAMS
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book

    render json: {message: t("message.books.not_found")},
           status: :not_found
  end

  def load_foreign_values
    @cats = Category.sorted_by_name
    @publishers = Publisher.sorted_by_name
    @authors = Author.sorted_by_name
  end

  def serialized_books
    ActiveModelSerializers::SerializableResource.new(
      @books,
      each_serializer: BookSerializer
    ).as_json
  end
end
