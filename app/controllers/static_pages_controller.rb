class StaticPagesController < ApplicationController
  def landing
    @is_user_logged_in = false
  	if signed_in?
  		@reviews = current_user.reviews
  		@feed_items = current_user.feed.paginate(page: params[:page])
    end

    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags

  end

  def home
    @invert_header = true
    @is_user_logged_in = true
    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @viewing_own_profile = [true,false].sample
  end

  def help
    @invert_header = true
    @is_user_logged_in = true
    @qas = StaticPagesHelper::SAMPLE_DATA.questions_and_answer
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
  end

  def about
  end

  def contact
  end
end
