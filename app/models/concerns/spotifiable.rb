class Spotifyable < ActiveRecord::Base

  BASE_URL = "https://api.spotify.com/v1"

  def self.get(slug, query = nil) #add if query condition
    res = nil

    res = HTTParty.get(slug, query)
    res = JSON.parse(res.body, symbolize_names: true)

    res
  end

end
