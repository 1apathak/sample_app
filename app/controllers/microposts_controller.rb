class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
  end

 def create
    @micropost = current_user.microposts.build(micropost_params)
      
      link = micropost_params['content']
      code = (link).split(/v=/)
      if (code.last)
        code = (code.last).split(/&/)

        @micropost.content = 'http://www.youtube.com/watch?v=' + code.first

        requestString = 'http://gdata.youtube.com/feeds/api/videos/' + code.first + '?v=2'
        @doc = Nokogiri::XML(open(requestString))
        @duration = ActionController::Base.helpers.strip_tags(@doc.xpath('//yt:duration').attr("seconds").text)
        @duration = @duration.to_i
        @micropost.duration = @duration
      end

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to current_user
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to current_user
  end

   private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end