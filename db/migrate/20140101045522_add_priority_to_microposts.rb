class AddPriorityToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :priority, :boolean, default: false
  end
end
