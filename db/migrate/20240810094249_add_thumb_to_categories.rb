class AddThumbToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :thumb, :string
  end
end
