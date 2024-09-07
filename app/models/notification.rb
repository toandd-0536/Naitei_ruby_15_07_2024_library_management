class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificationable, polymorphic: true
  enum status: {unread: 0, read: 1}
  validates :content, presence: true,
            length: {maximum: Settings.models.noti.content.max_length}
end
