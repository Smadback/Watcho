class AddKeyToEntries < ActiveRecord::Migration
  def change
    add_column('entries', 'key', :integer)
  end
end
