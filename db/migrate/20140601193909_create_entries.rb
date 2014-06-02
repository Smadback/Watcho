class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.integer :lastepisode
      t.integer :lastseason
      t.string :releaseday
      t.integer :user_id, :null => false, :references => [:user, :id]
      t.string :link

      t.timestamps
    end
  end
end
