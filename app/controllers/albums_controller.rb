class AlbumsController < ActionController::Base
  layout 'application'
  def show
    '''
    cache_key = Api::Spotify.cache_key(params[:spotify_id], "album")
    @album_spotify = Rails.cache.fetch(cache_key)
    @album = Album.where(spotify_id: params[:spotify_id])

    unless @album_spotify
      @album_spotify = Api::Spotify.album(params[:spotify_id])
      Rails.cache.fetch(cache_key) { @album_spotify  }
    end
    '''
    default_data
    @reviews_tab_active = true
  end

  def search
    queries_album_name = params[:name]
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @albums = AsyncHelper::SAMPLE_DATA.albums(5)
  end

  private
  def default_data
    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @songs = StaticPagesHelper::SAMPLE_DATA.songs
    @is_on_album_page = true
    @invert_header = true
    @is_user_logged_in = true
  end

end
