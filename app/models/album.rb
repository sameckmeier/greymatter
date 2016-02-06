class Album < ActiveRecord::Base

  has_many :reviews
  has_many :artists, through: :album_relationships, source: :artist
  has_one :spotify_album

  def self.build(args)
    res = Album.where(name: args[:name], spotify_id: args[:spotify_id])[0]

    unless res
      res = Album.new

      res.name = args[:name]
      res.spotify_id = args[:spotify_id]
      sa = SpotifyAlbum.build(res.id, args)

      res.save!
    end

    res
  end

end
