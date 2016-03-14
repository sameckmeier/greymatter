class ArtistsController < ActionController::Base
  layout 'application' #<--- not sure why i had to do this. Controller is not picking up layout
  def show
    @artist_spotify = Api::Spotify.artist(params[:spotify_id])
    @artist = Artist.where(spotify_id: params[:spotify_id])
    @popular_albums = Api::Spotify.artists_albums(params[:spotify_id])
    @albums = Artist.where(spotify_id: @popular_albums.map { |as| as[:id] })

    @is_user_logged_in = true
    @reviews = StaticPagesHelper::SAMPLE_DATA.album_feeds
    @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
    @tags = StaticPagesHelper::SAMPLE_DATA.tags
  end

end
