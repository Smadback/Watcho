class WelcomeController < ApplicationController
  
  def index
    
# -------------------------------------------------------------------------------  
# ---- Alle News auslesen und absteigend (neueste News zuerst) sortieren
# -------------------------------------------------------------------------------  
    @news = News.order(created_at: :desc)
    
    @title = "Smadbook"
    @subtitle = "the mvwebapplication"
    
  end
end