class Admin::EpisodesController < AdminController
  before_action :load_episode, only: %i(edit update destroy)
  before_action :load_books, except: %i(index)

  def index
    @pagy, @episodes = pagy Episode.sorted_by_created, items: Settings.page
    @breadcrumb_items = [{name: t(".index.title")}]
  end

  def new
    @episode = Episode.new
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_episodes_path},
      {name: t(".new.title")}
    ]
  end

  def create
    @episode = Episode.new episode_params
    handle_thumb_upload
    if @episode.save
      flash[:success] = t "message.episodes.created"
      redirect_to admin_episodes_path, status: :see_other
    else
      flash[:danger] = t "message.episodes.create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_episodes_path},
      {name: @episode.name, url: edit_admin_episode_path(@episode)},
      {name: t(".edit.title")}
    ]
  end

  def update
    handle_thumb_upload if params[:episode][:thumb].present?
    if @episode.update episode_params
      flash[:success] = t "message.episodes.updated"
      redirect_to admin_episodes_path
    else
      flash[:danger] = t "message.episodes.update_fail"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @episode.destroy
      flash[:success] = t "message.episodes.deleted"
    else
      flash[:danger] = t "message.episodes.delete_fail"
    end
    redirect_to admin_episodes_path
  end

  private
  def episode_params
    params.require(:episode).permit Episode::EPISODE_PARAMS
  end

  def load_books
    @books = Book.sorted_by_name
  end

  def load_episode
    @episode = Episode.find_by id: params[:id]
    return if @episode

    flash[:danger] = t "message.episodes.not_found"
    redirect_to root_url
  end

  def handle_thumb_upload
    uploaded_io = params[:episode][:thumb]
    filename = SecureRandom.hex + File.extname(uploaded_io.original_filename)

    storage = Settings.file_storage
    permissions = Settings.file_permissions
    File.open(Rails.root.join(storage, filename), permissions) do |file|
      file.write(uploaded_io.read)
    end

    @episode.thumb = filename
  end
end
