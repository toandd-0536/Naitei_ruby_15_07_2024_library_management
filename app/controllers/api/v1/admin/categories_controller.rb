class Api::V1::Admin::CategoriesController < AdminController
  before_action :load_cat, only: %i(show update destroy)

  def index
    @q = Category.ransack(params[:q])
    @pagy, @categories = pagy(@q.result.sorted_by_created, items: Settings.page)
    render json: {
      categories: serialized_categories,
      pagy: @pagy
    }, status: :ok
  end

  def show
    render json: {
      category: CategorySerializer.new(@cat)
    }, status: :ok
  end

  def create
    @cat = Category.new category_params

    if @cat.save
      render json: {
        message: t("message.categories.created"),
        category: CategorySerializer.new(@cat)
      }, status: :created
    else
      render json: {errors: @cat.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    if @cat.update category_params
      render json: {
        message: t("message.categories.updated"),
        category: CategorySerializer.new(@cat)
      }, status: :ok
    else
      render json: {errors: @cat.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    if @cat.destroy
      render json: {
        message: t("message.categories.deleted")
      }, status: :ok
    else
      render json: {message: t("message.categories.delete_fail")},
             status: :unprocessable_entity
    end
  end

  private

  def load_cat
    @cat = Category.find_by id: params[:id]
    return if @cat

    render json: {message: t("message.categories.not_found")},
           status: :not_found
  end

  def category_params
    params.require(:category).permit Category::CATEGORY_PARAMS
  end

  def serialized_categories
    ActiveModelSerializers::SerializableResource.new(
      @categories,
      each_serializer: CategorySerializer
    )
  end
end
