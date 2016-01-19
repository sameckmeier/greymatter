module Api
  module Spotify

    MIN_FIELDS = [:name, :id, :model, :images, :source]
    BASE_URL = "https://api.spotify.com/v1"

    belongs_to :spotify_album

    class << self

      def get(slug, query)
        res = nil

        url = "#{BASE_URL}/#{slug}/#{format_query(q)}"
        res = HTTParty.get(url)
        res = JSON.parse(res.body, symbolize_names: true)

        res
      end

      def fuzzy_search(query)
        res = []

        query = "/search?type=artist,album&q=#{format_query(query)}"
        response = HTTParty.get("#{BASE_URL}/#{query}")

        albums = JSON.parse(response.body, symbolize_names: true)[:albums][:items]
        artists = JSON.parse(response.body, symbolize_names: true)[:artists][:items]

        res = albums.concat(artists).map { |json| translate_search_json(json) }

        res
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

    end
  end
end
