class Admin::PublishersController < AdminController
  before_action :load_publisher, only: %i(show edit update destroy)

  def index
    @q = Publisher.ransack(params[:q])
    @pagy, @publishers = pagy(@q.result.sorted_by_created, items: Settings.page)
    @breadcrumb_items = [{name: t(".index.title")}]
  end

  def show
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_publishers_path},
      {name: @publisher.name}
    ]
  end

  def new
    @publisher = Publisher.new
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_publishers_path},
      {name: t(".new.title")}
    ]
  end

  def create
    @publisher = Publisher.new publisher_params
    if @publisher.save
      flash[:success] = t "message.publishers.new"
      redirect_to admin_publisher_path(@publisher), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_publishers_path},
      {name: @publisher.name, url: admin_publisher_path(@publisher)},
      {name: t(".edit.title")}
    ]
  end

  def update
    if @publisher.update publisher_params
      flash[:success] = t "message.publishers.updated"
      redirect_to admin_publisher_path(@publisher)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @publisher.destroy
      flash[:success] = t "message.publishers.deleted"
    else
      flash[:danger] = t "message.publishers.delete_fail"
    end
    redirect_to admin_publishers_path
  end

  private

  def publisher_params
    params.require(:publisher).permit Publisher::PUBLISHER_PARAMS
  end

  def load_publisher
    @publisher = Publisher.find_by id: params[:id]
    return if @publisher

    flash[:danger] = t "message.publishers.not_found"
    redirect_to root_url
  end
end
