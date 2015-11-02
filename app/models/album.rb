class Album < ActiveRecord::Base

  def self.build(spotify_json)
    res = Album.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]
    res.type = spotify_json[:type]
    res.genres = spotify_json[:genres]
    res.images = spotify_json[:images]
    res.popularity = spotify_json[:popularity]
    res.tracks = spotify_json[:tracks]

    res.save!
  end

end
