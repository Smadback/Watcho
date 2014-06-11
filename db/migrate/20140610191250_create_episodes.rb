class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.integer :season_id, :references => [:season, :id]
      t.integer :number, :null => false
      t.date :starts_at

      t.timestamps
    end
  end
  
  def self.down
    drop_table :episodes
  end
end