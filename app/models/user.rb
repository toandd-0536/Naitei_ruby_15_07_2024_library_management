class User < ApplicationRecord
  USER_PARAMS = [:name, :email, :dob, :phone, :lost_time,
                :blacklisted, :activated].freeze
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
  has_many :ratings, dependent: :destroy

  enum role: {admin: 0, user: 1}

  validates :name, presence: true,
            length: {maximum: Settings.models.user.name.max_length}
  validates :password, presence: true,
            length: {minimum: Settings.models.user.password.min_length},
            allow_nil: true
  validates :email, presence: true,
            length: {maximum: Settings.models.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
