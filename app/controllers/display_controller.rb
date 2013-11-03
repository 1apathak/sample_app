class DisplayController < ApplicationController

require 'nokogiri'
require 'open-uri'

def index
 # @results = Project.search(params[:search])
   @user = User.find_by(email: params[:search].downcase)
   if !@user
   	flash.now[:error] = 'Could not find that user' # Not quite right!
   	redirect_to root_url
	else
		@micropost = @user.microposts.sample
		portions = @micropost.content.split(/v=/)
		requestString = 'https://gdata.youtube.com/feeds/api/videos/' + portions.last + '?v=2'
		@doc = Nokogiri::XML(open(requestString))
		@duration = @doc.xpath('//yt:duration').attr("seconds").text
		@duration = ActionController::Base.helpers.strip_tags(@duration)

		@title = @doc.at_css("title").text
		@title = ActionController::Base.helpers.strip_tags(@title)

		@displayVid=1
		
	end

end

def update
	#@youtubeString = 'http://www.youtube.com/watch?v=' + params[:vid]
	@mymicropost = Micropost.find_by(content: 'http://www.youtube.com/watch?v=' + params[:vid]) #get the micropost
	
	if @mymicropost.present?
		#if the duration of the video isn't listed, get it from the youtube api
		if @mymicropost.duration==0
			requestString = 'https://gdata.youtube.com/feeds/api/videos/' + params[:vid] + '?v=2'
			@doc = Nokogiri::XML(open(requestString))
			@duration = ActionController::Base.helpers.strip_tags(@doc.xpath('//yt:duration').attr("seconds").text)
			@duration = @duration.to_i
			@mymicropost.duration = @duration
		end

		@mymicropost.lastwatch = DateTime.now
		@mymicropost.quality += params[:like].to_i
		@mymicropost.secondswatched += params[:duration].to_i
		@mymicropost.timesplayed += 1

		@mymicropost.save
		@success=1
	else
		@success=0
	end

	@displayVid=1
end


end
