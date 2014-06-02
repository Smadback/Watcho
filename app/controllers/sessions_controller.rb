class SessionsController < ApplicationController

  def show

  end

  def new

  end

  def create
    #user = User.where(:conditions => ["lower(name) = ?", params[:email].downcase])

    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Login successful!"
    else
      flash.now.alert = "Wrong email or password!"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logout successful!"
  end

end