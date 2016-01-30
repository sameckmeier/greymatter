class SpotifyAlbumRelationship < ActiveRecord::Base
  belongs_to :spotify_album
	belongs_to :spotify_artist
	validates :spotify_album_id, presence: true
	validates :spotify_artist_id, presence: true
end
