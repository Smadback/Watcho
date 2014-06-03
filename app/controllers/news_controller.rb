class NewsController < ApplicationController
  
  def index
    @news = News.order(created_at: :desc)
  end
  
  def new
    @news = News.new
  end
  
  def create
    news = News.new(news_parameters)
    news.user_id = current_user.id
    
    if news.save
      redirect_to news_index_path, :notice => "News creation successful"
    else
      render "new"
    end
  end

  # Strong parameters definition
  private
  
  def news_parameters
    params.require(:news).permit(:title, :text, :author)
  end

  
end
