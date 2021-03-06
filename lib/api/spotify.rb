module Api
  module Spotify

    ARTIST_FIELDS = [:name, :id, :model, :images, :source]
    ALBUM_FIELDS = [:name, :id, :model, :images, :release_date, :tracks, :genres, :source, :artists, :artist, :duration]
    TRACKS_FIELDS = [:id, :name, :preview_url, :track_number, :duration_ms]
    MIN_FIELDS = [:name, :id, :model, :images, :source]
    BASE_URL = "https://api.spotify.com/v1"

    class << self

      def fuzzy_search(query)
        res = []

        query = "/search?type=artist,album&q=#{format_query(query)}"
        response = HTTParty.get("#{BASE_URL}/#{query}")

        albums = JSON.parse(response.body, symbolize_names: true)[:albums][:items]
        artists = JSON.parse(response.body, symbolize_names: true)[:artists][:items]

        res = albums.concat(artists).map { |json| translate_search_json(json) }

        res
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

      def cache_key(spotify_id, spotify_type)
        "/#{spotify_type}/#{spotify_id}"
      end

      def translate_search_json(json)
        res = {}

        MIN_FIELDS.each { |f| res[f] = json[f] }
        res[:source] = :spotify
        res[:model] = json[:type]

        res
      end

      def format_query(query)
        query.gsub("\s", "%20")
      end

      def translate_artist_json(json)
        res = {}

        ARTIST_FIELDS.each { |f| res[f] = json[f] }
        res[:model] = "artist"
        res[:source] = :spotify

        res
      end

      def translate_album_json(json)
        res = {}

        ALBUM_FIELDS.each { |f| res[f] = json[f] }

        res[:artist] = translate_artist_json(res[:artists][0]) if res[:artists]

        if res[:tracks]
          res[:tracks] = translate_tracks_json(res[:tracks])
          res[:duration] = 0
          res[:tracks].each { |track| res[:duration] += ((track[:duration_ms]/1000)/60) }
        end

        res[:model] = "album"
        res[:source] = :spotify

        res
      end

      def translate_tracks_json(tracks)
        res = []

        res = tracks[:items].map do |track|
          t = {}; TRACKS_FIELDS.each { |f| t[f] = track[f] }; t
        end

        res
      end

    end
  end
end
