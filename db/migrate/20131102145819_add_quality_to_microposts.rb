class AddQualityToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :quality, :decimal, default: 0
  end
end
