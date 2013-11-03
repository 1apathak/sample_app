class AddStatsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :duration, :integer, default: 0
    add_column :microposts, :secondswatched, :integer, default: 0
    add_column :microposts, :timesplayed, :integer, default: 0
  end
end
