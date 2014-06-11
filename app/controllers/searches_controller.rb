class SearchesController < ApplicationController
  
  def new 
    @search = Search.new
  end

# -------------------------------------------------------------------------------   
# ---- Suche nach Serien mithilfe eines eingegebenen Namens
# -------------------------------------------------------------------------------    
  def create
    
    if(!params[:search][:name].nil?)
    
      @shows = Hash.new
      # Ersetzen der Leerzeichen in dem Suchwert durch Unterstriche (Game of Thrones => Game_of_Thrones)
      search = params[:search][:name].parameterize.underscore
 
      response = HTTParty.get("http://services.tvrage.com/feeds/search.php?show=#{search}")
      # response = {"Results" => 
                         # {"show" => {"showid" => "24493", "name" => "Game of Thrones", "airday" => "Sunday", "airtime" => "8 pm", "timezone" => "Euh"}}}
                         
      shows_hash = response['Results']['show']                
      
      # -------------------------------------------------------  
      # ---- Wenn mehr als 1 Serie gefunden wurde
      # -------------------------------------------------------                                     
      if (shows_hash.kind_of?(Array))    
        shows_hash.each do |key|
            @shows[key['name']] = key['showid']
        end          
      else
        
        # -------------------------------------------------------  
        # ---- Wenn nur 1 Serie gefunden wurde
        # ------------------------------------------------------- 
        @shows[shows_hash['name']] = shows_hash['showid']
      end
      
    end
    
    @search = Search.new
    render 'new'
  end
  
end