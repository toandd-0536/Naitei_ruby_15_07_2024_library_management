class AddLostReasonToBorrowBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :borrow_books, :lost_reason, :text
  end
end
