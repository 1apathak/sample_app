class DisplayController < ApplicationController

def index
 # @results = Project.search(params[:search])
   @user = User.find_by(email: params[:search].downcase)
   if !@user
   	flash.now[:error] = 'Could not find that user' # Not quite right!
   	redirect_to root_url
	else
		@micropost = @user.microposts.sample
	end

end


end
