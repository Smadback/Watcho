class ChangeForeignKeysInUserShows < ActiveRecord::Migration
  def change
    
    rename_column :user_shows, :user, :user_id
    rename_column :user_shows, :show, :show_id
    
  end
end
