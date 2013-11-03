class AddLastwatchToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :lastwatch, :datetime
  end
end
