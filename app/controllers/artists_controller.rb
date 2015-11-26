class ArtistsController < ActionController::Base
  layout 'application' #<--- not sure why i had to do this. Controller is not picking up layout
  def show
    '''
    artist_cache_key = Artist.cache_key(params[:spotify_id], "artist")
    @artist_spotify = Rails.cache.fetch(cache_key)
    @artist = Artist.where(spotify_id: params[:spotify_id])

    if @artist_spotify
      if Time.now - @artist[:albums_updated_at] >= 3.days
        albums = Api::Spotify.artists_albums(params[:spotify_id])
        @artist_spotify.merge({ albums: albums, albums_updated_at: Time.now })
        Rails.cache.delete(cache_key)
        Rails.cache.fetch(cache_key) { @artist_spotify }
      end
    else
      @artist_spotify = Api::Spotify.artist(params[:spotify_id])
      albums = Api::Spotify.artists_albums(params[:spotify_id])
      @artist_spotify.merge({ albums: albums, albums_updated_at: Time.now })
      Rails.cache.fetch(cache_key) { @artist_spotify }
    end
    '''
    @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
    @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags

  end

end
