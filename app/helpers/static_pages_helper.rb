module StaticPagesHelper
  module SAMPLE_DATA
    def self.popular_albums
      popular_albums = []
        for n in 0...9
          #popular albums dummy content
          popular_albums.push(
              {name: Faker::Lorem.words(2).join(' '), artist: Faker::Name.name}
          )
        end
      return popular_albums
    end

    def self.album_feeds
      album_feeds = []
      bool_vals = [true, false]
      for n in 0...5
          #album feeds dummy content
          album_feeds.push(
              {
                  user: Faker::Name.name,
                  time_ago: Faker::Date.between(5.days.ago, Date.today),
                  album: Faker::Lorem.words(2).join(' '),
                  artist: Faker::Name.name,
                  rating: Faker::Number.decimal(1),
                  content: Faker::Lorem.paragraph,
                  has_comment: bool_vals.sample
              }
          )
        end
      return album_feeds
    end

    def self.top_writers
      top_writers = []
        for n in 0...3
          #top writers dummy content
          top_writers.push({name: Faker::Name.name})
        end
      return top_writers
    end

    def self.tags
      return ['Taylor Swift', 'Apple Music', 'Drake', 'Spotify', 'Diplo', 'Apple Music', 'Drake', 'Spotify', 'Diplo']
    end
  end
end
