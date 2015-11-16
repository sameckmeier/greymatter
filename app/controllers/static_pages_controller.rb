class StaticPagesController < ApplicationController
  def old_home
  	if signed_in?
  		@reviews = current_user.reviews
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
