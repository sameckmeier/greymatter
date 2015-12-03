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
end
