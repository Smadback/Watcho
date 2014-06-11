class AddLastseasonAndLastepisodeToUserShows < ActiveRecord::Migration
  def change
    
    add_column('user_shows', 'lastseason', :integer)
    add_column('user_shows', 'lastepisode', :integer)
    add_column('user_shows', 'link', :string)
    
  end
end
