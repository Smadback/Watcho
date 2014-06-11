class AddEpisodesAvailableToUserShows < ActiveRecord::Migration
  def change
    add_column('user_shows', 'episodes_available', :integer, default: 0)
  end
end