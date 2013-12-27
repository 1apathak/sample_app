class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :user_images, [:user_id, :created_at]
  end
end
