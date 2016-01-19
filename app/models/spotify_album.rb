class SpotifyAlbum < Spotifyable

  FIELDS = [
    :name, :id, :images,
    :release_date, :genres,
    :duration
  ]
  RELATIONSHIPS = {
    artists: SpotifyArtist,
    tracks: SpotifyTracks
  }
  FUZZY_SEARCH_SLUG = "search?type=album&q="
  IDS_SEARCH_SLUG = "albums?ids="

  has_one :album
  has_many :spotify_artists, through: :spotify_artist_relationships, source: :spotify_artist
  has_many :spotify_tracks

  def self.build(json)
    res = self.where(s_id: json[:id], name: json[:name])[0]

    unless res
      res = self.new

      FIELDS.each do |f|
        if f == :id
          res.s_id = json(f)
        else
          res.send(f, json(f))
        end
      end

      res.save!

      RELATIONSHIPS.each do |k,v|
        json(k).each { |j| res.build_relationship(v, k, j) }
        build_duration(active_record_objs) if k == :tracks
      end
    end

    res
  end

  def self.search(query)
    res = []

    response = get(FUZZY_SEARCH_SLUG, query)
    ids = (response[:albums][:items].map { |album| album[:id] }).join(",")
    response = get(IDS_SEARCH_SLUG, ids)

    response[:albums].each do |json|
      album = build(json)
      res << album
    end

    res
  end

  private
  def build_duration
    res = 0

    tracks.each { |track| duration += ((track.duration_ms/1000)/60) }
    self.duration = res
    self.save!

    res
  end

end
