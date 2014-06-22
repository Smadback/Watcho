class Season < ActiveRecord::Base
  belongs_to(:show)
  has_many(:episode)

# -------------------------------------------------------------------------------   
# ---- Setter-Methode für "number"
# -------------------------------------------------------------------------------   
  # def number=(value)
    # # Logging
    # logger.debug {"Umwandeln #{value} (Season-Klasse) in Integer"}  
#     
    # season_number = Integer(value, 10)
    # write_attribute(:number, season_number)
  # end
  
end
