class UserShowsController < ApplicationController
  
  def index
  end

  def new
  end

  def create
  end

# -------------------------------------------------------------------------------   
# ---- Leitet weiter zur edit.html.erb von user_shows
# -------------------------------------------------------------------------------    
  def edit
    @user_show = UserShow.find(params[:id])
  end

# -------------------------------------------------------------------------------   
# ---- Aktualisiert die Informationen des Serieneintrags in der Liste
# -------------------------------------------------------------------------------  
  def update
    user_show = UserShow.find(params[:id])
    
    if user_show.update_attributes(user_show_parameters)
      redirect_to root_path
    else
      redirect_to edit_user_user_show_path(:user_id => current_user.id, :show_id => params[:show_id]), :alert => "Edit failed!"
    end
  end
  
# -------------------------------------------------------------------------------   
# ---- Hinzufügen einer Serie zur eigenen Liste
# -------------------------------------------------------------------------------    
  def add_show_to_list    
    user = current_user

    # -------------------------------------------------------  
    # ---- Überprüfen, ob die Serie schon in der Datenbank vorhanden ist, 
    # ---- wenn nicht, wird sie neu angelegt
    # ------------------------------------------------------- 
    show_exists = Show.exists?(params['show_id'])
     
    unless show_exists
      #show_infos = HTTParty.get("http://services.tvrage.com/feeds/showinfo.php?sid=#{params['show_id']}")
      show_infos = {"Showinfo" => {"showid"=> "24493", "showname" => "Game of Thrones", "airtime" => "21:00", "airday" => "Sunday", "timezone" => "GMT-5 +DST"}}
      
      show = Show.new
      show.id = show_infos['Showinfo']['showid']
      show.title = show_infos['Showinfo']['showname']
      show.airday = show_infos['Showinfo']['airday']
      show.airtime = show_infos['Showinfo']['airtime']
      show.timezone = show_infos['Showinfo']['timezone']
      
      saved = show.save
    else
      # Serieneintrag schon in der Liste
      redirect_to new_search_path, :alert => "This show is already in your list"
    end

    # -------------------------------------------------------
    # ---- Neuen User_Show Eintrag machen, mit der gesuchten Serie und dem
    # ---- angemeldeten Benutzer, falls nicht schon vorhanden
    # --------------------------------------------------------  
    if (saved || show_exists)
      user_show_exists = UserShow.exists?(:user_id => current_user.id, :show_id => params['show_id'])
      
      unless user_show_exists
        user_show = UserShow.new
        user_show.user = current_user
        show = Show.find_by(id: params['show_id'])
        user_show.show = show
        
        if user_show.save
          
          #season_info = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{params['show_id']}")
           season_info = {"Show" => 
                                { "name" => "Game of Thrones",
                                  "Episodelist" => 
                                      {"Season" => 
                                            [{"episode" => [{"seasonnum" => "01", "airdate" => "2013-03-31"},
                                                            {"seasonnum" => "02", "airdate" => "2013-04-07"},
                                                            {"seasonnum" => "03", "airdate" => "2013-04-14"},
                                                            {"seasonnum" => "04", "airdate" => "2013-04-21"},
                                                            {"seasonnum" => "05", "airdate" => "2013-04-28"},
                                                           ], "no" => "3"},
                                             {"episode" => [{"seasonnum" => "06", "airdate" => "2014-05-11"},
                                                            {"seasonnum" => "07", "airdate" => "2014-05-18"},
                                                            {"seasonnum" => "08", "airdate" => "2014-06-01"},
                                                            {"seasonnum" => "09", "airdate" => "2014-06-08"},
                                                            {"seasonnum" => "10", "airdate" => "2014-06-15"},
                                                           ],"no" => "4"}]}}}
                                                           
          # --------------------------------------------------------
          # ---- Wenn nur eine Staffel vorhanden ist
          # --------------------------------------------------------                                                      
          if (season_info['Show']['totalseasons'] == "1")
            
            season = season_info['Show']['Episodelist']['Season']
            season_number = Integer(season['no'], 10)
            season = Season.new
            season.show_id = show.id
            season.number = season_number
            season.save
            
            season_info['Show']['Episodelist']['Season']['episode'].each do |episode|
              if(!episode['airdate'].eql?("0000-00-00"))
                episode_number = Integer(episode['seasonnum'], 10)
                starts_at = Date.parse(episode['airdate'])
                episode = Episode.new
                episode.season_id = season.id
                episode.number = episode_number
                episode.starts_at = starts_at
                episode.save
              end
            end
          else
            
            # --------------------------------------------------------
            # ---- Iterieren der Staffeln der hinzugefügten Serie, 
            # ---- bei mehr als einer Staffel
            # --------------------------------------------------------
            counter = 0                                          
            season_info['Show']['Episodelist']['Season'].each do |season| 
              season_number = Integer(season['no'], 10)
              season = Season.new
              season.show_id = show.id
              season.number = season_number
              season.save
  
              # --------------------------------------------------------
              # ---- Iterieren der Episoden der Staffeln der hinzugefügten Serie
              # --------------------------------------------------------               
              season_info['Show']['Episodelist']['Season'][counter]['episode'].each do |episode|
                if(!episode['airdate'].eql?("0000-00-00"))
                  episode_number = Integer(episode['seasonnum'], 10)
                  starts_at = Date.parse(episode['airdate'])
                  episode = Episode.new
                  episode.season_id = season.id
                  episode.number = episode_number
                  episode.starts_at = starts_at
                  episode.save
                end
              end
              counter = counter + 1
            end
          end   
          
          # Serieneintrag konnte erfolgreich gespeichert werden
          redirect_to root_path, :notice => "#{user_show.show.title} was successfully added to your list."
        else
          # Beim Speichern ist ein Fehler aufgetreten
          redirect_to new_search_path, :alert => "An error occured."
        end
      end
    else
      redirect_to root_path
    end
  end

# -------------------------------------------------------------------------------   
# ---- Lastepisode wird um 1 erhöht
# -------------------------------------------------------------------------------      
  def last_episode_up
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.last_episode_up

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end

# -------------------------------------------------------------------------------   
# ---- Lastepisode wird um 1 verringert
# -------------------------------------------------------------------------------    
  def last_episode_down
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.last_episode_down

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end

# -------------------------------------------------------------------------------   
# ---- Lastseason wird um 1 erhöht
# -------------------------------------------------------------------------------    
  def last_season_up
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.last_season_up

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end

# -------------------------------------------------------------------------------   
# ---- Lastseason wird um 1 verringert
# -------------------------------------------------------------------------------    
  def last_season_down
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.last_season_down

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end

# -------------------------------------------------------------------------------   
# ---- Episodes_available wird um 1 erhöht
# -------------------------------------------------------------------------------    
  def episodes_available_up
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.episodes_available_up

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end

# -------------------------------------------------------------------------------   
# ---- Episodes_available wird um 1 verringert
# -------------------------------------------------------------------------------    
  def episodes_available_down
    user_show = UserShow.find_by(user_id: current_user.id, show_id: params[:show_id])
    
    unless user_show.nil?
      # Wenn der Serieneintrag gefunden wurde
      user_show.episodes_available_down

      if user_show.save
        redirect_to root_path
      else
        redirect_to root_path, :alert => "Edit failed!"
      end
    else
      # Wenn der Serieneintrag nicht gefunden wurde
      redirect_to root_path, :alert => "An error occured!"
    end
  end
  
# -------------------------------------------------------------------------------   
# ---- STRONG PARAMETERS
# -------------------------------------------------------------------------------   
  private
  def user_show_parameters
    params.require(:user_show).permit(:title, :lastepisode, :lastseason, :episodes_available, :link)
  end
  
end
