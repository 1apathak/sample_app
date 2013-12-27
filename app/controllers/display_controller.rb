class DisplayController < ApplicationController

require 'nokogiri'
require 'open-uri'

def index
 # @results = Project.search(params[:search])
   @user = User.find_by(email: params[:search].downcase)
   if !@user
	   	flash.now[:error] = 'Could not find that user' # Not quite right!
	   	@email = params[:search].downcase
	   	@flikr = 'i_still_believe_in_u'
	   	redirect_to signup_url(:email => @email, :flikr => @flikr, :signup => 'true')
	else
		number=(1..2).to_a.sample
		if (number==1)
			@microposts = @user.microposts.order(:quality).reverse_order #return posts in  order
		else
			@microposts = @user.microposts.order(:quality).shuffle #return posts in random order
		end

		@microposts = @user.microposts.order(:quality).reverse_order #TAKE OUT

	found=0
	increment=0
#skip if we've watched in the past 60 minutes, if all have been watched, search within the past 2 hours, etc
		while (found==0) do
			increment=increment+1
			@microposts.each do |i|
				if (i.lastwatch.nil? || ((DateTime.now - (increment*60).minutes) > i.lastwatch)) 
					@micropost = i
					next if (@micropost.videxists == 2)

					portions = @micropost.content.split(/v=/)
					test = 'KI7qk_y1YDE'

					requestString = 'http://gdata.youtube.com/feeds/api/videos/' + portions.last + '?v=2'
					#requestString = 'http://gdata.youtube.com/feeds/api/videos/' + test + '?v=2'

					@displayVid=1
					#check if the video is valid or not. If nothing, flag it.
						begin
							@doc = Nokogiri::XML(open(requestString))
							@duration = @doc.xpath('//yt:duration').attr("seconds").text
							@duration = ActionController::Base.helpers.strip_tags(@duration)
							@title = @doc.at_css("title").text
							@title = ActionController::Base.helpers.strip_tags(@title)			
						rescue Exception => e
							@displayVid=0
							@micropost.update_attribute(:videxists, 2)
						end
						
						#@title = @doc.xpath('//media:restriction')
						#render :text => @title.text.index('CA')
						@title = @doc.xpath('//media:restriction')
						unless (@title.nil?)
							if (!@title.text.index('CA').nil? || !@title.text.index('US').nil?)
								#@micropost.videxists=2
								#@success = @micropost.save!
								@micropost.update_attribute(:videxists, 2)
								@displayVid=0
							end
						end

					if @displayVid==1
						found=1
						@micropost.update_attribute(:videxists, 1)
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


		
	end #end else

end #end def index

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
