class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :text
      t.integer :user_id, :null => false, :references => [:user, :id]
      
      t.timestamps
    end
  end
end
