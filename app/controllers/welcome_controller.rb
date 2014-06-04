class WelcomeController < ApplicationController
  
  def index
    @episodes = Array.new(0, :Episode)
              
# -------------------------------------------------------------------------------   
# ---- Wenn jemand eingeloggt ist
# -------------------------------------------------------------------------------  
    if(!current_user.nil?)
      @entries = current_user.entries
    
# -------------------------------------------------------------------------------      
# ---- Alle Listeneinträge der Benutzers durch-iterieren
# -------------------------------------------------------------------------------    
      @entries.each do |entry|
          key = entry.key
          
          # Wenn die Serie per API eingetragen wurde
          if(!key.nil?)
            response = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{key}")
            # response = {"Show" => 
                                # { "name" => "Game of Thrones",
                                  # "Episodelist" => 
                                      # {"Season" => 
                                            # [{"episode" => [{"seasonnum" => "01", "airdate" => "2013-03-31"},
                                                            # {"seasonnum" => "02", "airdate" => "2013-04-07"},
                                                            # {"seasonnum" => "03", "airdate" => "2013-04-14"},
                                                            # {"seasonnum" => "04", "airdate" => "2013-04-21"},
                                                            # {"seasonnum" => "05", "airdate" => "2013-04-28"},
                                                           # ], "no" => "3"},
                                             # {"episode" => [{"seasonnum" => "06", "airdate" => "2014-05-11"},
                                                            # {"seasonnum" => "07", "airdate" => "2014-05-18"},
                                                            # {"seasonnum" => "08", "airdate" => "2014-06-01"},
                                                            # {"seasonnum" => "09", "airdate" => "2014-06-08"},
                                                            # {"seasonnum" => "10", "airdate" => "2014-06-15"},
                                                           # ],"no" => "4"}]}}}       
                                                                                                                                       
# -------------------------------------------------------------------------------                  
# ---- Iterieren der gefundenen Episoden zu allen Serien die der User in seiner Liste hat
# ---- und Speicherung dieser in einem Array
# -------------------------------------------------------------------------------             
             if (response['Show']['totalseasons'] == "1")
                 
               season = response['Show']['Episodelist']['Season']
               
               season['episode'].each do |episode|
                 if(!episode['airdate'].eql?("0000-00-00"))
                   episode = Episode.new(response['Show']['name'], response['Show']['Episodelist']['Season']['no'], episode['seasonnum'], episode['airdate'])
                   @episodes.push(episode)
                 end
               end
             else
# -------------------------------------------------------------------------------                  
# ---- Es gibt mehrere Stafeln die durchiteriert werden müssen
# -------------------------------------------------------------------------------                   
               response['Show']['Episodelist']['Season'].each do |season| 
                 
                 season['episode'].each do |episode|
                   if(!episode['airdate'].eql?("0000-00-00"))
                     episode = Episode.new(response['Show']['name'], season['no'], episode['seasonnum'], episode['airdate'])
                     @episodes.push(episode)
                   end
                 end
                 
               end
             end
          end
       end
    end
    
# -------------------------------------------------------------------------------  
# ---- Alle News auslesen und absteigend (neueste News zuerst) sortieren
# -------------------------------------------------------------------------------  
    @news = News.order(created_at: :desc)
    
  end
end