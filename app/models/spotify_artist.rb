class SpotifyArtist < ActiveRecord::Base

  FIELDS = [:name, :id, :images]

  has_one :artist
  has_many :spotify_albums, through: :spotify_artist_relationships, source: :spotify_album

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
      build_albums
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

    response = get("artists/#{s_id}/albums", query)
    res = json[:items].map { |j| SpotifyAlbum.build(j, self.id) }

    res
  end

end
