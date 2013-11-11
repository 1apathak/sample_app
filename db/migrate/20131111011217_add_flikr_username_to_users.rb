class AddFlikrUsernameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :flikr_name, :string
  end
end
