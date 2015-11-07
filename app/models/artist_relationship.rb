class ArtistRelationship < ActiveRecord::Base
  belongs_to :user
	belongs_to :artist
	validates :user_id, presence: true
	validates :artist_id, presence: true
end
