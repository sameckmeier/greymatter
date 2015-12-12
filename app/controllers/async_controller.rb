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
        dom_to_update = '#pop-niche-content' #use appropriate selectors for jQuery purpose
      when 'niche-albums'
        @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
        @rendered_content = view_context.render 'shared/niche_albums'
        dom_to_update = '#pop-niche-content' #use appropriate selectors for jQuery purpose
    end
    render json: {content: @rendered_content, dom_to_update: dom_to_update, status: 'OK'}
  end
end
