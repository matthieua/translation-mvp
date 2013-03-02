class ChangeColumnNameOnUsersTable < ActiveRecord::Migration
  def up
    change_column :users, :name, :string, :null => true
    change_column :users, :password_digest, :string,  :null => false
  end

  def down
    change_column :users, :name, :string, :null => false
    change_column :users, :password_digest, :string, :null => true
  end
end
