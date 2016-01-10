class AlbumsController < ActionController::Base
  layout 'application'
  def show
    @album_spotify = Api::Spotify.album(params[:id])
    # @album = Album.where(spotify_id: params[:spotify_id])
    @songs = @album_spotify[:tracks]
    @popular_albums = Api::Spotify.artists_albums(@album_spotify[:artist][:id])
    pp @popular_albums
    default_data
    @reviews_tab_active = true
  end

  def search
    queries_album_name = params[:name]
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @albums = Api::Spotify.albums_search(queries_album_name)
  end

  private
  def default_data
    @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
    @is_on_album_page = true
    @invert_header = true
    @is_user_logged_in = true
  end

end
