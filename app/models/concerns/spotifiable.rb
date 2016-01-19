class Spotifyable < ActiveRecord::Base

  def self.get(slug, query)
    res = nil

    res = HTTParty.get(slug, query)
    res = JSON.parse(res.body, symbolize_names: true)

    res
  end

  def build_relationship(model, type, json)
    res = model.build(json, self)
    SpotifyAttachment.build(self.id, res.id, type)
    res
  end

end
