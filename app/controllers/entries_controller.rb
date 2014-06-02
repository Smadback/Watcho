class EntriesController < ApplicationController

  def index
    @entries = current_user.entries
  end

  def show
  end

  # HTML-Seite zum erstellen neuer Einträge
  def new
    @series = Series.new
  end

  # Methode zum erstellen neuer Einträge - wird von der Form von 'new' aufgerufen
  def create
    user = current_user
    entry = user.entries.new(entry_parameters)

    if entry.save
      redirect_to user_entries_path(current_user.id), :notice => 'Entry creation successful'
    else
      render 'new'
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    entry = Entry.find(params[:id])
    if entry.update_attributes(entry_parameters)
      redirect_to user_entries_path(current_user.id)
    else
      redirect_to user_entries_path(current_user.id), :notice => "Edit failed!"
    end
  end

  def destroy
    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to user_entries_path(current_user.id)
  end

  def episode_up
    entry = Entry.find(params[:entry_id])
    entry.lastepisode = entry.lastepisode + 1

    if entry.save
      redirect_to user_entries_path(current_user.id)
    else
      redirect_to user_entries_path(current_user.id), :notice => "Edit failed!"
    end
  end

  def episode_down
    entry = Entry.find(params[:entry_id])
    entry.lastepisode = entry.lastepisode - 1

    if entry.save
      redirect_to user_entries_path(current_user.id)
    else
      redirect_to user_entries_path(current_user.id), :notice => "Edit failed!"
    end
  end

  def season_up
    entry = Entry.find(params[:entry_id])
    entry.lastseason = entry.lastseason + 1
    entry.lastepisode = 0

    if entry.save
      redirect_to user_entries_path(current_user.id)
    else
      redirect_to user_entries_path(current_user.id), :notice => "Edit failed!"
    end
  end

  def season_down
    entry = Entry.find(params[:entry_id])
    entry.lastseason = entry.lastseason - 1
    entry.lastepisode = 0

    if entry.save
      redirect_to user_entries_path(current_user.id)
    else
      redirect_to user_entries_path(current_user.id), :notice => "Edit failed!"
    end
  end

  # Strong parameters definition
  private
  def entry_parameters
    params.require(:entry).permit(:title, :lastepisode, :lastseason, :releaseday, :rating, :link)
  end


end