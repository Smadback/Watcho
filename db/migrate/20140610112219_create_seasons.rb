class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table "seasons" do |t|
      t.integer  "show_id", :references => [:show, :id] 
      t.integer  "number", :null => false
    end
  end
  
  def self.down
    drop_table :seasons
  end
end
