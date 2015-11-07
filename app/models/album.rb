class Album < ActiveRecord::Base

  def self.build(spotify_json)
    res = Album.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]

    res.save!
  end

end
