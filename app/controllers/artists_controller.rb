class ArtistsController < ActionController::Base

  def show
    artist_cache_key = Artist.cache_key(params)
    @artist = Rails.cache.fetch(cache_key)

    if @artist
      if Time.now - @artist[:albums_updated_at] >= 3.days
        albums = Api::Spotify.artists_albums(params[:spotify_id])
        @artist.merge({ albums: albums, albums_updated_at: Time.now })
        Rails.cache.delete(cache_key)
        Rails.cache.fetch(cache_key) { @artist }
      end
    else
      @artist = Api::Spotify.artist(params[:spotify_id])
      albums = Api::Spotify.artists_albums(params[:spotify_id])
      @artist.merge({ albums: albums, albums_updated_at: Time.now })
      Rails.cache.fetch(cache_key) { @artist }
    end
  end

end
