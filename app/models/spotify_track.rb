class SpotifyTrack < Spotifyable

  FIELDS = [:id, :name, :preview_url, :track_number, :duration_ms]

  belongs_to :spotify_album

  def self.build(json, spotify_album_id)
    res = self.new

    res.set_fields(FIELDS, json)
    res.spotify_album_id = spotify_album_id

    res.save!
  end

end
