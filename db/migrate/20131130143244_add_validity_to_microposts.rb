class AddValidityToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :videxists, :integer
  end
end
