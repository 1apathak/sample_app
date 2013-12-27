class User < ActiveRecord::Base
  require 'flickraw'

  has_many :microposts, dependent: :destroy
  has_many :user_images, dependent: :destroy
	before_save { self.email = email.downcase }
	before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

   has_secure_password
   validates :password, length: { minimum: 6 }, :on => :create
   validate :flikr_validate_exists

def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!
  UserMailer.password_reset(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end


  def flikr_validate_exists
    if !(:flikr_name.blank?)
      FlickRaw.api_key="803f036ec6d01e3ac0c1ca99bbc55260"
      FlickRaw.shared_secret="93e43a71a0731237"
      begin
        @id = flickr.people.findByUsername(:username => self.flikr_name).id
        #errors.add(:flikr_name, @id)
      rescue Exception => e
        errors.add(:flikr_name, "Invalid Flikr Name")
      end

      if @id == "Invalid Flikr Name"
        errors.add(:flikr_name, "Invalid Flikr Name")
      end
      
      unless @id.nil?
      list = flickr.photos.search(:user_id => @id)
      imageCount = (list.count)
      end

      if imageCount==0
        errors.add(:flikr_name, "No available images in this account!")
      end


    end

end
end