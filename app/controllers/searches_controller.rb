class SearchesController < ApplicationController
  
  def new 
    @search = Search.new
  end
  
  def create
    if(!params[:search][:name].nil?)
      search = params[:search][:name].parameterize.underscore
 
      @response = HTTParty.get("http://services.tvrage.com/feeds/search.php?show=#{search}")
      # @response = {"Results" => 
                        # {"show" => [{"showid" => "24493", "name" => "Game of Thrones"}, 
                                    # {"showid" => "37350", "name" => "King of Thrones"}
                                   # ]}}
    end
    
    @search = Search.new
    render 'new'
  end
  
end