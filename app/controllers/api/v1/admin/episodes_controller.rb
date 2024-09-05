class Api::V1::Admin::EpisodesController < AdminController
  before_action :load_episode, only: %i(update destroy)
  before_action :load_books, except: %i(index)

  def index
    @pagy, @episodes = pagy Episode.sorted_by_created, items: Settings.page
    render json: {
      episodes: serialized_episodes,
      pagy: @pagy
    }, status: :ok
  end

  def create
    @episode = Episode.new episode_params
    handle_thumb_upload

    if @episode.save
      send_notification_to_favorited_users @episode
      token = encode_token(episode_id: @episode.id)

      render json: {
        message: t("message.episodes.created"),
        episode: EpisodeSerializer.new(@episode),
        token:
      }, status: :created
    else
      render json: {errors: @episode.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    handle_thumb_upload if params[:episode][:thumb].present?
    token = encode_token episode_id: @episode.id

    if @episode.update episode_params
      render json: {
        message: t("message.episodes.updated"),
        episode: EpisodeSerializer.new(@episode),
        token:
      }, status: :ok
    else
      render json: {errors: @episode.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    if @episode.destroy
      render json: {
        message: t("message.episodes.deleted")
      }, status: :ok
    else
      render json: {message: t("message.episodes.delete_fail")},
             status: :unprocessable_entity
    end
  end

  private

  def episode_params
    params.require(:episode).permit Episode::EPISODE_PARAMS
  end

  def load_books
    @books = Book.sorted_by_name
    return if @books

    render json: {message: t("message.books.not_found")},
           status: :not_found
  end

  def load_episode
    @episode = Episode.find_by id: params[:id]
    return if @episode

    render json: {message: t("message.episodes.not_found")},
           status: :not_found
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

  def send_notification_to_favorited_users episode
    favorited_users = User.favorited_for_book(episode.book)

    favorited_users.each do |user|
      Pusher.trigger(
        "user-#{user.id}",
        "episode-created",
        {
          message: t(
            "controllers.episodes.new_episode",
            name: episode.book.name
          ),
          episode: EpisodeSerializer.new(episode)
        }
      )
    end
  end

  def serialized_episodes
    ActiveModelSerializers::SerializableResource.new(
      @episodes,
      each_serializer: EpisodeSerializer
    )
  end
end
