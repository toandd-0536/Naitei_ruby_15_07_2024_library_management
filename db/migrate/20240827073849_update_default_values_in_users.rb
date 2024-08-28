class UpdateDefaultValuesInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :lost_time, from: nil, to: 0
    change_column_default :users, :blacklisted, from: nil, to: false
    change_column_default :users, :activated, from: nil, to: true
  end
end
