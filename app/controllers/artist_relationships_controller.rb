class ArtistRelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
			@artist = Artist.find(params[:followed_artist_id])
			unless @artist
        artist_spotify = Rails.cache.fetch(Artist.cache_key(params[:followed_artist_spotify_id]))
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
