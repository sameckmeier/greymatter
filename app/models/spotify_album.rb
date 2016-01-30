class SpotifyAlbum < Spotifyable

  FIELDS = [:name, :id, :images, :release_date, :genres, :duration]
  RELATIONSHIPS = { artists: SpotifyArtist, tracks: SpotifyTracks }
  FUZZY_SEARCH_SLUG = "search?type=album&q="
  IDS_SEARCH_SLUG = "albums?ids="

  has_one :album
  has_many :spotify_artists, through: :spotify_album_relationships, source: :spotify_artist
  has_many :spotify_tracks

  def self.build(json, spotify_artist_id = nil)
    res = self.where(s_id: json[:id], name: json[:name])[0]

    unless res
      res = self.new

      FIELDS.each do |f|
        v = json[f]
        if f == :id
          res.s_id = v
        else
          res.send(f, v)
        end
      end

      res.save!

      RELATIONSHIPS.each do |type,model|
        json(type).each do |j|
          case type
          when :tracks
            j[:items].each do |track|
              model.build(track, res.id)
              build_duration
            end
          when :artists
            SpotifyAlbumRelationship.create!(
              spotify_album_id: self.id,
              spotify_artist_id: spotify_artist_id || (SpotifyArtist.build(j)).id
            )
          end
        end
      end
    end

    res
  end

  def self.search(query)
    res = []

    response = get(FUZZY_SEARCH_SLUG, query)
    ids = response[:albums][:items].map { |album| album[:id] }).join(",")
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
