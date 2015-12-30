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
        #random number to simulate ID/token
        temp_rand = Faker::Number.number(6)
          #album feeds dummy content
          album_feeds.push(
              {
                  token: temp_rand,
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

    def self.top_writers(amt=3)
      top_writers = []
        for n in 0...amt
          #top writers dummy content
          top_writers.push({name: Faker::Name.name})
        end
      return top_writers
    end

    def self.songs
      songs = []
      for n in 0...5
        #top writers dummy content
        songs.push(
            {
                name: Faker::Lorem.words(2).join(' '),
                downloads: Faker::Number.number(10)
            }
        )
      end
      return songs
    end


    def self.tags
      return ['Taylor Swift', 'Apple Music', 'Drake', 'Spotify', 'Diplo', 'Apple Music', 'Drake', 'Spotify', 'Diplo']
    end

    def self.questions_and_answer
      qas = []
      for n in 0...5
        #top writers dummy content
        qas.push(
            {
                question: Faker::Lorem.sentence(2, true),
                answer: Faker::Lorem.paragraph
            }
        )
      end
      return qas
    end
  end
end
