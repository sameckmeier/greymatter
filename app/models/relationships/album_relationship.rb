class AlbumRelationship < ActiveRecord::Base
  belongs_to :album
	belongs_to :artist
	validates :album_id, presence: true
	validates :artist_id, presence: true
end
