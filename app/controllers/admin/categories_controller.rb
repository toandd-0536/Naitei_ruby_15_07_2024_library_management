class Admin::CategoriesController < AdminController
  before_action :load_cat, only: %i(show edit update destroy)
  before_action :load_cats, except: %i(index show)

  def index
    @pagy, @categories = pagy Category.sorted_by_created, items: Settings.page
    @breadcrumb_items = [{name: t(".index.title")}]
  end

  def show
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_categories_path},
      {name: @cat.name}
    ]
  end

  def new
    @cat = Category.new
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_categories_path},
      {name: t(".new.title")}
    ]
  end

  def create
    @cat = Category.new category_params
    if @cat.save
      flash[:success] = t "message.categories.created"
      redirect_to admin_categories_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_categories_path},
      {name: @cat.name, url: admin_category_path(@cat)},
      {name: t(".edit.title")}
    ]
  end

  def update
    if @cat.update category_params
      flash[:success] = t "message.categories.updated"
      redirect_to admin_category_path(@cat)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @cat.destroy
      flash[:success] = t "message.categories.deleted"
    else
      flash[:danger] = t "message.categories.delete_fail"
    end
    redirect_to admin_categories_path
  end

  private
  def load_cats
    @cats = Category.sorted_by_name
  end

  def category_params
    params.require(:category).permit Category::CATEGORY_PARAMS
  end

  def load_cat
    @cat = Category.find_by id: params[:id]
    return if @cat

    flash[:danger] = t "message.categories.not_found"
    redirect_to root_url
  end
end
