class Api::V1::Admin::AuthorsController < AdminController
  before_action :load_author, only: %i(show update destroy)

  def index
    @pagy, @authors = pagy Author.sorted_by_name, items: Settings.page
    render json: {
      authors: serialized_authors,
      pagy: @pagy
    }, status: :ok
  end

  def show
    render json: {
      author: AuthorSerializer.new(@author)
    }, status: :ok
  end

  def create
    @author = Author.new author_params

    if @author.save
      render json: {
        message: t("message.authors.created"),
        author: AuthorSerializer.new(@author)
      }, status: :created
    else
      render json: {errors: @author.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    if @author.update author_params
      render json: {
        message: t("message.authors.updated"),
        author: AuthorSerializer.new(@author)
      }, status: :ok
    else
      render json: {errors: @author.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    if @author.destroy
      render json: {
        message: t("message.authors.deleted")
      }, status: :ok
    else
      render json: {message: t("message.authors.delete_fail")},
             status: :unprocessable_entity
    end
  end

  private

  def author_params
    params.require(:author).permit Author::AUTHOR_PARAMS
  end

  def load_author
    @author = Author.find_by id: params[:id]
    return if @author

    render json: {message: t("message.authors.not_found")},
           status: :not_found
  end

  def serialized_authors
    ActiveModelSerializers::SerializableResource.new(
      @authors,
      each_serializer: AuthorSerializer
    )
  end
end
