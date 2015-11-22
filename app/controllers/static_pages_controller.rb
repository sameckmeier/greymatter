class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@reviews = current_user.reviews
  		@feed_items = current_user.feed.paginate(page: params[:page])
    end

    @popular_albums = []
    @album_feeds = []
    @top_writers = []
    for n in 0...9
      #popular albums dummy content
      @popular_albums.push(
          {name: Faker::Lorem.words(2).join(' '), artist: Faker::Name.name}
      )
    end

    for n in 0...5
      #album feeds dummy content
      @album_feeds.push(
          {
              user: Faker::Name.name,
              time_ago: Faker::Date.between(5.days.ago, Date.today),
              album: Faker::Lorem.words(2).join(' '),
              artist: Faker::Name.name,
              rating: Faker::Number.decimal(1),
              content: Faker::Lorem.paragraph
          }
      )
    end

    for n in 0...3
      #top writers dummy content
      @top_writers.push({name: Faker::Name.name})
    end

    @tags = ['Taylor Swift', 'Apple Music', 'Drake', 'Spotify', 'Diplo']

  end

  def help
  end

  def about
  end

  def contact
  end
end
