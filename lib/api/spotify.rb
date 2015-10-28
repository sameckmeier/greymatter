module Api
  module Spotify

    BASE_URL = "https://api.spotify.com/v1/search"

    def search(args)
      res = []

      query = "?type=#{args[:type].join('%20')}&q=#{args[:query].gsub!(\s, '%20')}"
      response = HttParty.get("#{BASE_URL}#{query}")
      json = format_json(response.body)

      res
    end

    def get(type, id)
    end

    def format_json(raw_json)
      res = []

      res = JSON.parse(raw_json)
      res = res[:items]
      res = res.map { |item| unpack_item(item) }

      res
    end

    def unpack_item(item)
      { name: item[:name], type: item[:type], id: item[:id], source: :spotify }
    end

    def to_active_record(spotify_json)
    end

  end
end
