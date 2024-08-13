class ChangeContentAndIntroToTextInEpisodes < ActiveRecord::Migration[7.0]
  def change
    change_column :episodes, :content, :text
    change_column :episodes, :intro, :text
  end
end
