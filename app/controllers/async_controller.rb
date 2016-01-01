class AsyncController < ApplicationController
  def typeahead_search
    @writers = AsyncHelper::SAMPLE_DATA.writers
    @artists = AsyncHelper::SAMPLE_DATA.artists
    @albums = AsyncHelper::SAMPLE_DATA.albums
    @results = {
        writers: @writers,
        artists: @artists,
        albums: @albums
    }
    @rendered_results = view_context.render 'async/search_results',
                                   locals: {
                                       results: @results
                                   }
    render json: {results: @rendered_results, status: 'OK'}
  end

  def current_user_menu
    @rendered_content = view_context.render 'async/user_drop_down'
    render json: {content: @rendered_content, status: 'OK'}
  end

  def current_user_notifications
    @notifications = [
        'People you follow wrote some reviews',
        'Your friend likes an album',
        'People you follow wrote some reviews',
        'Your friend likes an album'
    ]
    @rendered_content = view_context.render 'async/user_notifications',
                                            locals: {
                                                notifications: @notifications
                                            }
    render json: {content: @rendered_content, status: 'OK'}
  end

  def edit_current_user_info
    @rendered_content = view_context.render 'async/edit_user_profile_info'
    render json: {content: @rendered_content, status: 'OK'}
  end

  def save_current_user_info
    @rendered_content = view_context.render 'shared/user_profile_info'
    render json: {content: @rendered_content, status: 'OK'}
  end

  def load_content
    content_to_show = params[:content_to_load]
    case content_to_show
      when 'popular-albums'
        @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
        @rendered_content = view_context.render 'shared/popular_albums'

      when 'niche-albums'
        @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
        @rendered_content = view_context.render 'shared/niche_albums'

      when 'trending-reviews'
        @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
        @rendered_content = view_context.render 'shared/artist/trending_reviews'

      when 'album-trending-reviews'
        @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
        @rendered_content = view_context.render 'shared/album/trending_reviews'

      when 'biography'
        @bio = Faker::Lorem.paragraph(12)
        @rendered_content = view_context.render 'shared/artist/biography'

      when 'ymal-map'
        @rendered_content = view_context.render 'shared/album/ymal_map'

      when 'album-ymal-map'
        @rendered_content = view_context.render 'shared/album/ymal_map'

      when 'album-top-rated-reviews'
        @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
        @rendered_content = view_context.render 'shared/album/top_rated_reviews'

      when 'album-newest-reviews'
        @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
        @rendered_content = view_context.render 'shared/album/newest_reviews'
    end
    render json: {content: @rendered_content, status: 'OK'}
  end

  def album_feed_new_comment
    #validate album token, check if current user exist or has permission etc
    #log comment
    #if all is good, render comment and post back to script
    @rendered_content = view_context.render 'shared/user/comment', locals: {comment: params[:comment]}
    render json: {
        content: @rendered_content,
        album_token: params[:album_token],
        status: 'OK',
        request_type: 'post-new-album-comment'
    }
  end

  def new_album_review
    rated_value = params[:rated_val].to_i
    album_id_token = params[:album_id]
    #validate album
    #fetch album info by id/token
    #save review
    #post and update user
    render json: {
        status: 'OK',
        request_type: 'post-new-album-review'
    }
  end

  def fetch_more_album_feeds
    #get current page param
    #fetch next set of records
    #push results to partial
    @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds.paginate(per_page: 3)
    @rendered_content = view_context.render 'shared/album_feeds'
    render json: {
        content: @rendered_content,
        status: 'OK'
    }
  end
end
