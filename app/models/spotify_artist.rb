class SpotifyArtist < ActiveRecord::Base

  def self.build(spotify_json)
    res = Artist.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]

    res.save!
  end

  def artist(id)
    res = nil

    ck = cache_key(id, "artist")
    if Rails.cache.exist?(ck)
      res = Rails.cache.fetch(ck)
    else
      response = HTTParty.get("#{BASE_URL}/artists/#{id}")
      json = JSON.parse(response.body, symbolize_names: true)
      res = translate_artist_json(json)
      Rails.cache.fetch(ck) {res}
    end

    res
  end



end
