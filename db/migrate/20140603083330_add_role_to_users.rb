class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column('users', 'role', :integer, :references => [:role, :id])
  end
end