class Artist < ActiveRecord::Base

  def self.build(spotify_json)
    res = Artist.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]
    res.genres = spotify_json[:genres]
    res.images = spotify_json[:images]
    res.popularity = spotify_json[:popularity]
    res.tracks = spotify_json[:tracks]

    res.save!
  end

end
