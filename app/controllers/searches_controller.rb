class SearchesController < ApplicationController
  
  def new 
    @search = Search.new
  end
  
  def create
    if(!params[:search][:name].nil?)
      search = params[:search][:name].parameterize.underscore
 
      @response = HTTParty.get("http://services.tvrage.com/feeds/search.php?show=#{search}")
      print @response
    end
    
    @search = Search.new
    render 'new'
  end
  
end