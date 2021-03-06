class UsersController < ApplicationController

  def index
    @entries = current_user.entries
  end

  def new
    @user = User.new
    @title = "Registration"
    @subtitle = "be a part of us"
  end

  def create
    user = User.new(user_parameters)
    user.role = 'user'
    if user.save
      redirect_to root_url, :notice => "Registration successful"
    else
      render "new"
    end
  end

  def edit
    @title = "User profile"
    @subtitle = "this is who you are"
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(user_parameters)
      redirect_to profile_path
    else
      redirect_to profile_path, :notice => "Edit failed!"
    end
  end

  private

  def user_parameters
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end