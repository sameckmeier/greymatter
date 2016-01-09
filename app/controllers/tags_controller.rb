class TagsController < ApplicationController
  def show
    #get clicked tag
    clicked_tag = params[:phrase]
    #fetch all reviews with this tag

    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @songs = StaticPagesHelper::SAMPLE_DATA.songs
    @qas = StaticPagesHelper::SAMPLE_DATA.questions_and_answer
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @is_on_album_page = true
    @invert_header = true
    @is_user_logged_in = true
  end
end
