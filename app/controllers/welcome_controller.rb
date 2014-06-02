class WelcomeController < ApplicationController
  def index
    @entries = current_user.entries
    @response = HTTParty.get('http://services.tvrage.com/feeds/search.php?show=buffy')
  end
end