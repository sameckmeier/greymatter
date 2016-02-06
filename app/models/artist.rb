class Artist < ActiveRecord::Base

  has_many :artist_relationships, dependent: :destroy
  has_many :followers, through: :artist_relationships, source: :user
  has_one :spotify_artist

  def self.build(args)
    res = Artist.where(name: args[:name], spotify_id: args[:spotify_id])[0]

    unless res
      res = Artist.new

      res.name = args[:name]
      res.spotify_id = args[:spotify_id]
      sa = SpotifyArtist.build(res, args)

      res.save!
    end

    res
  end

end
