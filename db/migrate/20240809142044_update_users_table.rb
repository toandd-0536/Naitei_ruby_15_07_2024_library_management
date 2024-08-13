class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :dob, :date
    add_index :users, :email, unique: true
    change_column_default :users, :role, from: nil, to: 1
    change_column_default :users, :lost_time, from: nil, to: 0
    change_column_default :users, :blacklisted, from: nil, to: false
    change_column_default :users, :activated, from: nil, to: true
  end
end
