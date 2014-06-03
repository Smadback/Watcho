class EntriesController < ApplicationController

  # HTML-Seite zum erstellen neuer Einträge
  def new
    @entry = Entry.new
  end


  # Methode zum erstellen neuer Einträge - wird von der Form von 'new' aufgerufen
  def create
    user = current_user
    entry = user.entries.new(entry_parameters)
    
    # Wenn Lasstepisode oder Lastseason nil ist, auf 0 setzen um damit rechnen zu können
    if (entry.lastepisode.nil?)
      entry.lastepisode = 0
    end 
    if (entry.lastseason.nil?)
      entry.lastseason = 0
    end

    # Bei erfolgreichem Speichern weiterleiten
    if entry.save
      redirect_to root_path, :notice => 'TV show successfully added  '
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
      redirect_to root_path
    else
      redirect_to edit_user_entry_path(:user_id => current_user.id, :id => entry.id), :notice => "Edit failed!"
    end
  end


  def destroy
    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to root_path
  end


  def episode_up
    entry = Entry.find(params[:entry_id])
    entry.lastepisode = entry.lastepisode + 1

    if entry.save
      redirect_to root_path
    else
      redirect_to root_path, :notice => "Edit failed!"
    end
  end


  def episode_down
    entry = Entry.find(params[:entry_id])
    entry.lastepisode = entry.lastepisode - 1

    if entry.save
      redirect_to root_path
    else
      redirect_to root_path, :notice => "Edit failed!"
    end
  end


  def season_up
    entry = Entry.find(params[:entry_id])
    entry.lastseason = entry.lastseason + 1
    entry.lastepisode = 0

    if entry.save
      redirect_to root_path
    else
      redirect_to root_path, :notice => "Edit failed!"
    end
  end


  def season_down
    entry = Entry.find(params[:entry_id])
    entry.lastseason = entry.lastseason - 1
    entry.lastepisode = 0

    if entry.save
      redirect_to root_path
    else
      redirect_to root_path, :notice => "Edit failed!"
    end
  end
  
  
  # Serie, die per API gefunden wurde, zur Liste hinzufügen
  def add_show_to_list
    # Serieneintrag vorbereiten
    user = current_user
    entry = user.entries.new
    entry.key = params[:show_id]
    entry.title = params[:title]
    entry.lastepisode = 0
    entry.lastseason = 0
    
    # Bei erfolgreichem Speichern weiterleiten
    if (entry.save)
      redirect_to root_path
    else 
      redirect_to new_search_path, :notice => "Adding failed!"
    end
  end

  # Strong parameters definition
  private
  def entry_parameters
    params.require(:entry).permit(:title, :lastepisode, :lastseason, :releaseday, :link)
  end


end