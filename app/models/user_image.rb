class UserImage < ActiveRecord::Base
	attr_accessible :user_id, :image
	attr_accessor :email

	belongs_to :user
	mount_uploader :image, ImageUploader
end
