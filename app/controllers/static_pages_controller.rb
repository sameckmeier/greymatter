class StaticPagesController < ApplicationController
  def landing
  	if signed_in?
  		@reviews = current_user.reviews
  		@feed_items = current_user.feed.paginate(page: params[:page])
    end

    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags

  end

  def home
    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
  end

  def help
  end

  def about
  end

  def contact
  end
end
