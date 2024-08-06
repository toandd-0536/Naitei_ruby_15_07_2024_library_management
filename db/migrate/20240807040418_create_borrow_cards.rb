class CreateBorrowCards < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_time

      t.timestamps
    end
  end
end
