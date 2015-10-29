class SearchesController < ActionController::Base

  def show
    @spotify_items_hashes = Api::Spotify.search(params[:q])
  end

end
