class Album < ActiveRecord::Base

  has_many :reviews
  has_many :artists, through: :album_relationships, source: :artist

  attr_accessor :spotify_data

  def self.build(args)
    res = nil

    if args[:spotify_id]
      res = Album.where(name: args[:name], spotify_id: args[:spotify_id])[0]

      unless res
        res = Album.new

        res.name = args[:name]
        res.spotify_id = args[:spotify_id]

        res.save!
      end

      res.spotify_data = args[:spotify_album_json]
    end

    res
  end

end
