class AlbumsController < ActionController::Base

  def show
    cache_key = Album.cache_key(params)
    @album_spotify = Rails.cache.fetch(cache_key)
    @album = Album.where(spotify_id: params[:spotify_id])

    unless @album_spotify
      @album_spotify = Api::Spotify.album(params[:spotify_id])
      Rails.cache.fetch(cache_key) { @album_spotify  }
    end
  end

end
