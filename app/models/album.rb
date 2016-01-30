class Album < ActiveRecord::Base

  has_many :reviews
  has_many :artists, through: :album_relationships, source: :artist

  def self.build(args)
    res = Album.new

    res.name = args[:name]
    res.spotify_id = args[:id]

    sa = SpotifyAlbum.build(args)

    res.save!
  end

end
