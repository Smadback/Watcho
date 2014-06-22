class UserShowsController < ApplicationController
  
  def index
    @user_shows = UserShow.find_by_sql("SELECT * FROM user_shows WHERE user_id = '#{current_user.id}'")
    @title = "The List"
    @subtitle = "all your favorite shows neatly arranged"
  end

  def new
    @user_show = UserShow.new
    @user_show.show_id = params[:show_id]
    @title = "Add #{params[:title]} to your list"
  end

  def create
    user = current_user
    show_id = params[:user_show][:show_id]

    # -------------------------------------------------------  
    # ---- Überprüfen, ob die Serie schon in der Datenbank vorhanden ist, 
    # ---- wenn nicht, wird sie neu angelegt
    # ------------------------------------------------------- 
    show_exists = Show.exists?(show_id)
     
    unless show_exists
      # API-Aufruf zum bekommen allgemeiner Serieninfos
      show_infos = HTTParty.get("http://services.tvrage.com/feeds/showinfo.php?sid=#{show_id}")
      temp = show_infos['Showinfo']
      show = Show.new
      show.attributes = {id: temp['showid'], title: temp['showname'], airday: temp['airday'], 
                         airtime: temp['airtime'], timezone: temp['timezone']}
      saved = show.save
      
      logger.debug {"#{show.title} in Datenbank geschrieben"}
      
      # API-Aufruf zum bekommen der Episodenliste einer Serie
      season_info = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{show_id}")
      logger.debug {"[DEBUG] #{show.title}: #{season_info['Show']['totalseasons']} Staffel(n) vorhanden"}  
      
      # --------------------------------------------------------
      # ---- Wenn nur eine Staffel vorhanden ist
      # --------------------------------------------------------                                                      
      if (season_info['Show']['totalseasons'] == "1")
        only_one_season(show, season_info)
        
      # --------------------------------------------------------
      # ---- Wenn mehr als eine Staffel vorhanden ist
      # --------------------------------------------------------    
      else
        more_than_one_season(show, season_info)
      end
    else
      logger.debug {"[DEBUG] Serie(#{params[:user_show]['show_id']}) muss nicht in die Datenbank geschrieben werden"}
    end

    show_exists = Show.exists?(show_id)
    # -------------------------------------------------------
    # ---- Neuen User_Show Eintrag machen, mit der gesuchten Serie und dem
    # ---- angemeldeten Benutzer, falls nicht schon vorhanden
    # --------------------------------------------------------  
    if (show_exists)
      user_show_exists = UserShow.exists?(:user_id => current_user.id, :show_id => show_id)
      
      unless user_show_exists
        user_show = UserShow.new
        show = Show.find_by(id: show_id)
        user_show.attributes = {user: current_user, show: show, lastseason: params[:user_show][:lastseason], 
                                lastepisode: params[:user_show][:lastepisode], episodes_available: params[:user_show][:episodes_available], 
                                link: params[:user_show][:link]}
        
        if user_show.save
          # Serieneintrag konnte erfolgreich gespeichert werden
          redirect_to user_user_shows_path(:id => current_user.id), :notice => "#{user_show.show.title} was successfully added to your list."
        else
          # Beim Speichern ist ein Fehler aufgetreten
          redirect_to new_search_path, :alert => "An error occurred."
        end
      else
        # Beim Speichern ist ein Fehler aufgetreten
        redirect_to new_search_path, :alert => "The show is already in your list."  
      end
    else
      # Beim Speichern der Serie ist ein Fehler aufgetreten
      redirect_to new_search_path, :alert => "An error occurred."
    end
  end
 

# -------------------------------------------------------------------------------   
# ---- Leitet weiter zur edit.html.erb von user_shows
# -------------------------------------------------------------------------------    
  def edit
    @user_show = UserShow.find(params[:id])
    @title = "Edit a series entry"
  end



# -------------------------------------------------------------------------------   
# ---- Aktualisiert die Informationen des Serieneintrags in der Liste
# -------------------------------------------------------------------------------  
  def update
    user_show = UserShow.find(params[:id])
    
    if user_show.update_attributes(user_show_parameters)
      redirect_to user_user_shows_path(:user_id => current_user.id)
    else
      redirect_to edit_user_user_show_path(:user_id => current_user.id, :show_id => params[:show_id]), :alert => "Edit failed!"
    end
  end



# -------------------------------------------------------------------------------   
# ---- Löscht einen Eintrag aus der Serienliste
# -------------------------------------------------------------------------------   
  def destroy
    user_show = UserShow.find(params[:id])
    user_show.destroy
    redirect_to user_user_shows_path(:user_id => user_show.user_id), :notice => "#{user_show.show.title} successfully removed"
  end



# -------------------------------------------------------------------------------   
# ---- Wenn die Serie nur eine Staffel enthält
# -------------------------------------------------------------------------------      
  def only_one_season(show, season_info)
    logger.debug {"[DEBUG] Starte Staffel hinzufuegen"} #Logging 
    season_hash = season_info['Show']['Episodelist']['Season']
    season = add_season(show, season_hash)
    
    season_info['Show']['Episodelist']['Season']['episode'].each do |episode_hash|
      if(!episode_hash['airdate'].eql?("0000-00-00"))
        add_episode(season, episode_hash)   
      end
    end  
    logger.debug {"[DEBUG] Die Staffel hinzugefuegt"} #Logging    
  end
  
  
  
# -------------------------------------------------------------------------------   
# ---- Wenn die Serie mehr als eine Staffel besitzt
# -------------------------------------------------------------------------------      
  def more_than_one_season(show, season_info)
    logger.debug {"[DEBUG] Starte Staffeln hinzufuegen"} #Logging 
  
    # --------------------------------------------------------
    # ---- Iterieren der Staffeln der hinzugefügten Serie, 
    # ---- bei mehr als einer Staffel
    # --------------------------------------------------------
    counter = 0                                          
    season_info['Show']['Episodelist']['Season'].each do |season_hash| 
      season = add_season(show, season_hash)
  
      # --------------------------------------------------------
      # ---- Iterieren der Episoden der Staffeln der hinzugefügten Serie
      # --------------------------------------------------------               
      episode_hash = season_info['Show']['Episodelist']['Season'][counter]['episode']
        
        if (episode_hash.kind_of?(Array))
          
          # --------------------------------------------------------
          # ---- Die Staffel hat mehr als 1 Episdode
          # --------------------------------------------------------   
          episode_hash.each do |episode|
            if(!episode['airdate'].eql?("0000-00-00"))
              add_episode(season, episode)              
            end
          end
        else
        
          # --------------------------------------------------------
          # ---- Die Staffel hat nur 1 Episode
          # -------------------------------------------------------- 
          if(episode_hash['airdate'].eql?("0000-00-00"))
            add_episode(season, episode_hash)
          end
        end
      counter = counter + 1
    end
  
    logger.debug {"[DEBUG] Alle Staffeln hinzugefuegt"} #Logging    
  end  
  
  
  
# -------------------------------------------------------------------------------   
# ---- Speichern einer Episode einer Staffel
# -------------------------------------------------------------------------------    
  def add_episode(season, episode_hash)
    episode_number = Integer(episode_hash['seasonnum'], 10)
    episode_date = Date.parse(episode_hash['airdate'])
    episode = Episode.new
    episode.attributes = {season_id: season.id, number: episode_number, starts_at: episode_date}
    episode.save
    
    logger.debug {"[DEBUG] Episode #{episode_hash['epnum']} in die Datenbank geschrieben"}
    return episode 
  end    
  
  
  
# -------------------------------------------------------------------------------   
# ---- Speichern einer Staffel von einer Serie
# -------------------------------------------------------------------------------    
  def add_season(show, season_hash)
    season_number = Integer(season_hash['no'], 10)
    season = Season.new
    season.attributes = {show_id: show.id, number: season_number}
    season.save
    
    logger.debug {"[DEBUG] #{show.title}: Staffel #{season_number} in die Datenbank geschrieben"}
    return season   
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
