class SpotifyTrack < ActiveRecord::Base

  belongs_to :spotify_album

  def self.build(spotify_json)
    res = Artist.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]

    res.save!
  end

  def translate_tracks_json(tracks)
    res = []

    res = tracks[:items].map do |track|
      t = {}; TRACKS_FIELDS.each { |f| t[f] = track[f] }; t
    end

    res
  end

end
