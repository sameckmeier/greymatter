class SpotifyAlbum < Spotifyable

  FIELDS = [:name, :id, :images, :release_date, :genres, :duration]
  RELATIONSHIPS = { artists: SpotifyArtist, tracks: SpotifyTracks }
  FUZZY_SEARCH_SLUG = "search?type=album&q="
  IDS_SEARCH_SLUG = "albums?ids="

  belongs_to :album
  has_many :spotify_artists, through: :spotify_album_relationships, source: :spotify_artist
  has_many :spotify_tracks

  validates :album_id, presence: true

  def self.build(album_id, json)
    res = self.where(s_id: json[:id], name: json[:name])[0]

    unless res
      res = self.new

      res.set_fields(FIELDS, json)
      res.album_id = album_id
      res.save!

      RELATIONSHIPS.each do |type,model|
        json(type).each do |j|
          case type
          when :tracks
            j[:items].each do |track|
              model.build(track, res.id)
              res.build_duration
            end
          when :artists
            SpotifyAlbumRelationship.create!(
              spotify_album_id: res.id,
              spotify_artist_id: json[:spotify_artist_id] || (model.build(j)).id
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

  def build_duration
    res = 0

    spotify_tracks.each { |st| duration += ((st.duration_ms/1000)/60) }
    self.duration = res
    self.save!

    res
  end

end
