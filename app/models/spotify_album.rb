class SpotifyAlbum < ActiveRecord::Base

  has_many :reviews

  def self.build(spotify_json)
    res = Album.new

    res.name = spotify_json[:name]
    res.spotify_id = spotify_json[:id]

    res.save!
  end

  def albums_search(query)
    res = []

    search_query = "#{BASE_URL}/search?type=album&q=#{format_query(query)}"
    response = HTTParty.get(search_query)

    ids = JSON.parse(response.body, symbolize_names: true)[:albums][:items].map { |album| album[:id] }
    albums_response = HTTParty.get("#{BASE_URL}/albums?ids=#{ids.join(",")}")

    JSON.parse(albums_response.body, symbolize_names: true)[:albums].each do |json|
      album = translate_album_json(json)

      ck = cache_key(album[:id], album[:model])
      unless Rails.cache.exist?(ck)
        Rails.cache.fetch(ck) { album }
      end

      res << album
    end

    res
  end

  def album(id)
    res = nil

    ck = cache_key(id, "album")
    if Rails.cache.exist?(ck)
      res = Rails.cache.fetch(ck)
    else
      response = HTTParty.get("#{BASE_URL}/albums/#{id}")
      json = JSON.parse(response.body, symbolize_names: true)
      res = translate_album_json(json)
      Rails.cache.fetch(ck) {res}
    end

    res
  end

  def artists_albums(id)
    res = nil

    ck = cache_key(id, "albums")
    if Rails.cache.exist?(ck)
      res = Rails.cache.fetch(ck)
    else
      response = HTTParty.get("#{BASE_URL}/artists/#{id}/albums")
      json = JSON.parse(response.body, symbolize_names: true)
      res = json[:items].map { |j| translate_album_json(j) }
      Rails.cache.fetch(ck) {res}
    end

    res
  end

end
