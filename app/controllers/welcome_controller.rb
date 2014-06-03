class WelcomeController < ApplicationController
  def index
    
    if(!current_user.nil?)
      @entries = current_user.entries
    end
    
    # @response = HTTParty.get('http://services.tvrage.com/feeds/search.php?show=buffy')
    
  end
end