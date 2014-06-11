class UserShow < ActiveRecord::Base
  
  belongs_to(:show)
  belongs_to(:user)
  
# -------------------------------------------------------------------------------   
# ---- Lastepisode wird um 1 erhöht
# -------------------------------------------------------------------------------    
  def last_episode_up
    self.lastepisode = self.lastepisode + 1
  end
  
# -------------------------------------------------------------------------------   
# ---- Lastepisode wird um 1 verringert
# -------------------------------------------------------------------------------  
  def last_episode_down
    if self.lastepisode > 0
      self.lastepisode = self.lastepisode - 1
    end
  end

# -------------------------------------------------------------------------------   
# ---- Lastseason wird um 1 erhöht
# -------------------------------------------------------------------------------    
  def last_season_up
    self.lastseason = self.lastseason + 1
  end
  
# -------------------------------------------------------------------------------   
# ---- Lastseason wird um 1 verringert
# -------------------------------------------------------------------------------    
  def last_season_down
    if self.lastseason > 0
      self.lastseason = self.lastseason - 1
    end
  end
  
# -------------------------------------------------------------------------------   
# ---- Episodes_available wird um 1 erhöht
# -------------------------------------------------------------------------------    
  def episodes_available_up
    if self.episodes_available
      self.episodes_available = self.episodes_available + 1
    end
  end
  
# -------------------------------------------------------------------------------   
# ---- Episodes_available wird um 1 verringert
# -------------------------------------------------------------------------------    
  def episodes_available_down
    if self.episodes_available > 0
      self.episodes_available = self.episodes_available - 1
    end
  end
  
end
