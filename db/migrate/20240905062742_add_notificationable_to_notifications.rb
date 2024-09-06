class AddNotificationableToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :notificationable_type, :string
    add_column :notifications, :notificationable_id, :integer

    add_index :notifications, [:notificationable_type, :notificationable_id], name: "index_notificationable"
  end
end
