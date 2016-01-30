class SpotifyTrack < ActiveRecord::Base

  FIELDS = [:id, :name, :preview_url, :track_number, :duration_ms]

  belongs_to :spotify_album

  def self.build(spotify_json, spotify_album_id)
    res = self.new

    FIELDS.each do |f|
      v = spotify_json[f]
      if f == :id
        res.s_id = v
      else
        res.send(f, v)
      end
    end

    res.spotify_album_id = spotify_album_id
    res.save!
  end

end
