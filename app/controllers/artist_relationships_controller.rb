class ArtistRelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
			@artist = Artist.find(params[:followed_artist_id])
			unless @artist
				cache_key = Api::Spotify.cache_key(params[:followed_artist_spotify_id], "artist")
        artist_spotify = Rails.cache.fetch(cache_key)
				@artist = Artist.build(artist_spotify)
			end
		end

		current_user.follow_artist!(:artist, @artist)
		respond_to do |format|
			format.html { redirect_to @artist }
			format.js
		end
	end

	def destroy
		@user = ArtistRelationship.find(params[:user_id]).followed
		current_user.unfollow!(:artist, @artist)
		respond_to do |format|
			format.html { redirect_to @artist }
			format.js
		end
	end
end
