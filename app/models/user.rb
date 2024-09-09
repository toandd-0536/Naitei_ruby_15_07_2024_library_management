class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  USER_PARAMS = [:name, :email, :dob, :phone, :lost_time,
                :blacklisted, :activated].freeze
  CREATE_PARAMS = %i(name email password phone).freeze
  UPDATE_PARAMS = %i(name password_confirmation password phone).freeze
  VALID_EMAIL_REGEX = Regexp.new(Settings.models.user.email.regex_valid)
  has_many :carts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :episodes, through: :favorites, source: :favoritable,
            source_type: "Episode"
  has_many :authors, through: :favorites, source: :favoritable,
            source_type: "Author"
  has_many :publishers, through: :favorites, source: :favoritable,
            source_type: "Publisher"

  has_many :borrow_cards, dependent: :destroy
  has_many :borrow_books, through: :borrow_cards
  has_many :ratings, dependent: :destroy
  has_many :notifications, dependent: :destroy

  enum role: {admin: 0, user: 1}

  validates :name, presence: true,
            length: {maximum: Settings.models.user.name.max_length}
  validates :password,
            length: {minimum: Settings.models.user.password.min_length},
            allow_nil: true
  validates :email, presence: true,
            length: {maximum: Settings.models.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :phone, presence: true

  before_save :downcase_email
  before_update :blacklist

  scope(:favorited_for_book, lambda do |book|
    joins(:favorites)
      .where(
        favorites: {
          favoritable_type: "Episode",
          favoritable_id: book.episodes.ids
        }
      ).distinct
  end)

  def borrow_books_by_status status
    borrow_books.where status:
  end

  def self.ransackable_attributes _auth_object = nil
    %w(activated blacklisted created_at dob email
        id lost_time name phone role updated_at)
  end

  def self.generate_random_password
    SecureRandom.alphanumeric Settings.random_password_count
  end

  def currently_borrowing_episodes_count
    borrowing_episodes_count = BorrowBook.by_user(id).active.count
    cart_episodes_count = carts.count
    borrowing_episodes_count + cart_episodes_count
  end

  def can_borrow_episode? episode
    errors.clear
    validate_activation
    validate_blacklist
    validate_episode_in_cart episode
    validate_episode_quantity episode
    validate_borrowing_limit

    errors.empty?
  end

  def can_checkout_cart?
    errors.clear
    validate_activation
    validate_blacklist

    errors.empty?
  end

  private

  def downcase_email
    email.downcase!
  end

  def blacklist
    return unless lost_time >= 3

    self.activated = false
    self.blacklisted = true
  end

  def validate_activation
    return if activated

    errors.add :base, I18n.t("controllers.episodes.error_active")
  end

  def validate_blacklist
    return unless blacklisted

    errors.add :base, I18n.t("controllers.episodes.error_blacklist")
  end

  def validate_episode_in_cart episode
    return unless carts.exists? episode: episode

    errors.add :base, I18n.t("controllers.episodes.error_exists")
  end

  def validate_episode_quantity episode
    return if episode.qty >= 1

    errors.add :base, I18n.t("controllers.episodes.error_qty")
  end

  def validate_borrowing_limit
    return if currently_borrowing_episodes_count < Settings.max_book

    errors.add :base, I18n.t("controllers.episodes.error_max")
  end
end
