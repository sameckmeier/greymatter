class AlbumsController < ActionController::Base

  def show
    cache_key = Api::Spotify.cache_key(params[:spotify_id], "album")
    @album_spotify = Rails.cache.fetch(cache_key)
    @album = Album.where(spotify_id: params[:spotify_id])

    unless @album_spotify
      @album_spotify = Api::Spotify.album(params[:spotify_id])
      Rails.cache.fetch(cache_key) { @album_spotify  }
    end
  end

end
