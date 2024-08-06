class CreateBorrowBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_books do |t|
      t.references :borrow_card, null: false, foreign_key: true
      t.references :episode, null: false, foreign_key: true
      t.integer :status
      t.string :reason

      t.timestamps
    end
  end
end
