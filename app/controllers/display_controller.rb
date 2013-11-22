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

		@microposts = @user.microposts.order(:created_at).shuffle #return posts from newest to oldest (posted)
	
	found=0
	increment=0
#skip if we've watched in the past 60 minutes, if all have been watched, search within the past 2 hours, etc
	while (found==0) do
		increment=increment+1
		@microposts.each do |i|
			if (i.lastwatch.nil? || ((DateTime.now - (increment*60).minutes) > i.lastwatch)) 
				@micropost = i

				portions = @micropost.content.split(/v=/)
				test = '6QVtHogFrI0'

				requestString = 'http://gdata.youtube.com/feeds/api/videos/' + portions.last + '?v=2'
				
				begin
					@doc = Nokogiri::XML(open(requestString))
					@duration = @doc.xpath('//yt:duration').attr("seconds").text
					@duration = ActionController::Base.helpers.strip_tags(@duration)

					@title = @doc.at_css("title").text
					@title = ActionController::Base.helpers.strip_tags(@title)
					@displayVid=1
				rescue Exception => e
					@displayVid=0
				end

				if @displayVid==1
					found=1
					break
				end
			end
		end

		if (increment>5)
			@microposts = @user.microposts.order(:created_at).sample
			found=1
			@displayVid=1
			break
		end
	end


		
	end

end

def update
	#@youtubeString = 'http://www.youtube.com/watch?v=' + params[:vid]
	@mymicropost = Micropost.find_by(content: 'http://www.youtube.com/watch?v=' + params[:vid]) #get the micropost
	
	if @mymicropost.present?
		#if the duration of the video isn't listed, get it from the youtube api
		if @mymicropost.duration==0
			requestString = 'http://gdata.youtube.com/feeds/api/videos/' + params[:vid] + '?v=2'
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
