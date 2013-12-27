class AddImageToUserImage < ActiveRecord::Migration
  def change
    add_column :user_images, :image, :string
  end
end
