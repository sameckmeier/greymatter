class SpotifyArtist < ActiveRecord::Base

  FIELDS = [:name, :id, :images]
  RELATIONSHIPS = { albums: SpotifyArtist }

  has_one :artist
  has_many :spotify_albums

  def self.build(json, spotify_album=nil)
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

      RELATIONSHIPS.each do |k,v| { json(k).map { |j| res.build_relationship(v, k, j) } }
    end

    res
  end

  def self.search(id)
    res = nil

    response = HTTParty.get("#{BASE_URL}/artists/#{id}")
    json = JSON.parse(response.body, symbolize_names: true)
    res = translate_artist_json(json)
    Rails.cache.fetch(ck) {res}

    res
  end

  def self.albums(id)
    res = nil

    response = HTTParty.get("#{BASE_URL}/artists/#{id}/albums")
    json = JSON.parse(response.body, symbolize_names: true)
    res = json[:items].map { |j| translate(j) }

    res
  end

end
