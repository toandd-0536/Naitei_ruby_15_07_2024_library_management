class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :intro
      t.string :bio
      t.date :dob
      t.date :dod
      t.string :thumb
      t.string :thumb_img

      t.timestamps
    end
  end
end
