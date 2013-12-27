class UserImagesController < ApplicationController

  def index
  end

 def create
    @userimage = UserImage.new(params[:userimage])
    if !params[:userimage].nil?
      user = User.find_by(email: params[:userimage][:email].downcase)
      @userimage.user_id=user.id
      @userimage.save
      flash[:notice] = "successfully created a new user"
      redirect_to root_url
    else
      flash[:notice] = "Please upload a correct image and email address."
      render :action => 'new'
    end
  end


  def destroy
    @userimage = UserImage.find(params[:id])
    @userimage.destroy
    flash[:notice] = "Successfully destroyed painting."
    redirect_to root_url
  end

   private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def image_params
      params.require(:userimage).permit(:image, :user_id)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end