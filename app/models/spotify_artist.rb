class SpotifyArtist < Spotifyable

  FIELDS = [:name, :id, :images]

  belongs_to :artist
  has_many :spotify_albums, through: :spotify_artist_relationships, source: :spotify_album

  validates :artist_id, presence: true

  def self.build(artist_id, json)
    res = self.where(s_id: json[:id], name: json[:name])[0]

    unless res
      res = self.new

      res.set_fields(FIELDS, json)
      res.artist_id = artist_id
      res.save!

      res.build_albums
    end

    res
  end

  def self.search(spotify_id)
    res = self.where(s_id: spotify_id)[0]

    unless res
      response = get("artists/#{id}")
      res = build(response)
    end

    res
  end

  def build_albums
    res = nil

    response = get("artists/#{s_id}/albums")
    res = json[:items].map { |j| SpotifyAlbum.build(j, self.id) }

    res
  end

end
