module Api
  module Spotify

    ARTIST_FIELDS = [:name, :id, :model, :images, :source]
    ALBUM_FIELDS = [:name, :id, :model, :images, :release_date, :tracks, :genres, :source]
    TRACKS_FIELDS = [:id, :name, :preview_url, :track_number]
    SEARCH_FIELDS = [:name, :id, :model, :images, :source]
    BASE_URL = "https://api.spotify.com/v1"

    class << self

      def search(query)
        res = []

        query = "search?type=artist,album&q=#{format_query(query)}"
        response = HTTParty.get("#{BASE_URL}/#{query}")

        albums = JSON.parse(response.body, symbolize_names: true)[:albums][:items]
        artists = JSON.parse(response.body, symbolize_names: true)[:artists][:items]

        res = albums.concat(artists).map { |json| translate_search_json(json) }

        res
      end

      def artist(id)
        res = nil

        response = HTTParty.get("#{BASE_URL}/artists/#{id}")
        json = JSON.parse(response.body, symbolize_names: true)
        res = translate_artist_json(json)

        res
      end

      def album(id)
        res = nil

        response = HTTParty.get("#{BASE_URL}/albums/#{id}")
        json = JSON.parse(response.body, symbolize_names: true)
        res = translate_album_json(json)

        res
      end

      def artists_albums(id)
        res = nil

        response = HTTParty.get("#{BASE_URL}/artists/#{id}/albums")
        json = JSON.parse(response.body, symbolize_names: true)
        res = json[:items].map { |j| translate_album_json(j) }

        res
      end

      def cache_key(spotify_id, spotify_type)
        "/#{spotify_type}/#{spotify_id}"
      end

      def translate_search_json(json)
        res = {}

        SEARCH_FIELDS.each { |f| res[f] = json[f] }
        res[:source] = :spotify

        if json[:type] == "artist"
          res[:model] = :artist
        elsif json[:type] == "album"
          res[:model] = :album
        end

        res
      end

      def format_query(query)
        query.gsub!("\s", "%20")
      end

      def translate_artist_json(json)
        res = {}

        ARTIST_FIELDS.each { |f| res[f] = json[f] }
        res[:model] = :artist
        res[:source] = :spotify

        res
      end

      def translate_album_json(json)
        res = {}

        ALBUM_FIELDS.each { |f| res[f] = json[f] }
        res[:model] = :album
        res[:source] = :spotify

        res
      end

      def translate_tracks(tracks)
        res = []

        res = tracks[:items].map do |track|
          t = {}
          TRACKS_FIELDS.each { |f| t[f] = track[f] }
          t
        end

        res
      end

    end
  end
end
