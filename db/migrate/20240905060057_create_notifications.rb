class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
