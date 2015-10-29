module Api
  module Spotify

    BASE_URL = "https://api.spotify.com/v1"

    class << self

      def search(query)
        res = []

        query = "search?type=artist,album&q=#{query.gsub!(\s, '%20')}"
        response = HttParty.get("#{BASE_URL}/#{query}")

        albums = JSON.parse(response.body, symbolize_names: true)[:albums][:items]
        artists = JSON.parse(response.body, symbolize_names: true)[:artists][:items]
        res = albums.concat(artists).map { |json| translate_search_json(json) }

        res
      end

      def artist(id)
        res = nil

        response = HttParty.get("#{BASE_URL}/artists/#{id}")
        json = JSON.parse(response.body, symbolize_names: true)
        res = translate_artist_json(json)

        res
      end

      def album(id)
        res = nil

        response = HttParty.get("#{BASE_URL}/albums/#{id}")
        json = JSON.parse(response.body, symbolize_names: true)
        res = translate_album_json(json)

        res
      end

      def artists_albums(id)
        res = nil

        response = HttParty.get("#{BASE_URL}/artists/#{id}/albums")
        json = JSON.parse(response.body, symbolize_names: true)
        res = translate_album_json(json)

        res
      end

      def translate_search_json(json)
        res = { name: json[:name], id: json[:id], source: :spotify }

        if json[:type] == :artist
          res[:model] = ::Artist
        elsif json[:type] == :album
          res[:model] = ::Album
        end

        res
      end

      def translate_artist_json(json)
        { name: json[:name], id: json[:id], model: ::Artist, source: :spotify }
      end

      def translate_album_json(json)
        { name: json[:name], id: json[:id], model: ::Album, source: :spotify }
      end
    end
  end
end
