class Artist < ActiveRecord::Base

  has_many :artist_relationships, dependent: :destroy
  has_many :followers, through: :artist_relationships, source: :user

  def self.build(spotify_json)
    res = Artist.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]

    res.save!
  end

end
