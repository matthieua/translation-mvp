class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table "users", :force => true do |t|
      t.string   "name", :null => false
      t.string   "email", :null => false
      t.string   "country"
      t.string   "dropbox_uid"
      t.string   "dropbox_oauth_token"
      t.string   "dropobox_oauth_secret"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
