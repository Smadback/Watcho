class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title, :null => false
      t.string :airday
      t.string :airtime
      t.string :timezone

      t.timestamps
    end
  end
end
