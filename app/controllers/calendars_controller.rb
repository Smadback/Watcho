class CalendarsController < ApplicationController
  
  def index
    
    @episodes = Array.new
    user_shows = UserShow.find_by_sql("SELECT * FROM user_shows WHERE user_id = '#{current_user.id}'")
    
    # --------------------------------------------------------
    # ---- Iterieren der Serien der Liste
    # --------------------------------------------------------    
    user_shows.each do |user_show|
      show = Show.find(user_show.show.id)
      seasons = Season.find_by_sql("SELECT * FROM seasons WHERE show_id = '#{show.id}'")

      # --------------------------------------------------------
      # ---- Iterieren der Staffeln der Serie
      # --------------------------------------------------------          
      seasons.each do |season|
        all_episodes = Episode.find_by_sql("SELECT * FROM episodes WHERE season_id = #{season.id}")
        
        # --------------------------------------------------------
        # ----  Iterieren der Episoden der Serie
        # --------------------------------------------------------            
        all_episodes.each do |episode|
          @episodes<<episode
        end
      end
    end
    @title = "Calendar"
    @subtitle = "see what episode comes next"
    
  end
  
end
