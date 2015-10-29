class AlbumsController < ActionController::Base

  def show
    cache_key = Album.cache_key(params)
    @artist = Rails.cache.fetch(cache_key)

    unless @album
      @album = Api::Spotify.artist(params[:spotify_id])
      Rails.cache.fetch(cache_key) { res }
    end
  end

end
