class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.references :episode, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :body
      t.integer :rating

      t.timestamps
    end
  end
end
