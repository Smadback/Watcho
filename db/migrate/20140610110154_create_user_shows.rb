class CreateUserShows < ActiveRecord::Migration
  def self.up
    create_table :user_shows do |t|
      t.integer :user_id, :null => false, :references => [:user, :id]
      t.integer :show_id, :null => false, :references => [:show, :id]
      t.integer :lastseason, :default => 0
      t.integer :lastepisode, :default => 0
      t.string :link

      t.timestamps
    end
  end
  
  def self.down
    drop_table :user_shows
  end
end
