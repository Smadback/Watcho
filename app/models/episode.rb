class Episode < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar
  attr_accessor :show, :season_no, :episode_no, :starts_at
  
  def initialize(show, season_no, episode_no, starts_at)
    @show = show
    @season_no = season_no
    @episode_no = episode_no
    @starts_at = starts_at
  end
  
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :show, :season_no, :episode_no, :starts_at
end