module AsyncHelper
  module SAMPLE_DATA
    def self.writers
      writers = []
      for n in 0...1
        writer_name = Faker::Name.name
        writers.push({
                         name: writer_name,
                         location: "#{Faker::Address.city}, #{Faker::Address.state_abbr}",
                         title: ['Novice', 'Guru'].sample,
                         handler: "@#{writer_name.downcase.gsub(' ','')}"
                     })
      end
      return writers
    end
    def self.artists
      artists = []
      for n in 0...1
        artist_name = Faker::Name.name
        artists.push({
                         name: artist_name,
                         location: "#{Faker::Address.city}, #{Faker::Address.state_abbr}",
                         handler: "@#{artist_name.downcase.gsub(' ','')}"
                     })
      end
      return artists
    end

    def self.albums(amt_res=2)
      albums = []
      for n in 0...amt_res
        albums.push({
                         name: Faker::Lorem.words(3).join(' '),
                         artist: Faker::Name.name,
                         year: [2003,1999,2012,1978,2015,2010,2014,2009,2013].sample,
                         songs: Faker::Number.between(5, 20),
                         duration: Faker::Number.between(900, 5400)
                     })
      end
      return albums
    end
  end
end
