class Episode < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar
  
  belongs_to(:season)
end
