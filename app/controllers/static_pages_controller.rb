class StaticPagesController < ApplicationController
    def home
      if signed_in?

    	 @micropost = current_user.microposts.build if signed_in?
    	 @feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5) if signed_in?

       @microposts = current_user.microposts.order(:quality).reverse_order 

       countedDays = Array.new(7, 0)
       today = DateTime.now.to_date

       puts YAML::dump(current_user.email)

       @microposts.each do |i|
          if i.lastwatch.nil?
            next
          else
          postTime = i.lastwatch.to_date

          if (today-postTime > 7 || today-postTime < 0 )
            next
          end
          countedDays[today-postTime]+=1
          puts YAML::dump(i.lastwatch)
         end
      end

  #build the array of the view count for the days of the week (string)
      @daysArray = "["
      countedDays.reverse.each do |d|
        @daysArray << d.to_s()
        @daysArray << ","
      end
      @daysArray << "]"
      puts YAML::dump(@daysArray)


    end
  end #end home

  def help
  end

  def about
  end

  def contact
  end
end
