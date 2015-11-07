require 'rails_helper'

feature "Spotify Api" do

  scenario "Searches query should return results" do

    response = Api::Spotify.search("david bowie")
    success = true
    response.each do |r|
      Api::Spotify::SEARCH_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to true
  end

  scenario "Album query should return results" do

    heroes_by_david_bowie_id = "3lFioPGhn7x5Y3H3YbPV83"

    response = Api::Spotify.album("3lFioPGhn7x5Y3H3YbPV83")
    response.each do |r|
      Api::Spotify::ALBUM_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to true
  end

  scenario "Artist query should return results" do

    david_bowie_id = "0oSGxfWSnnOXhD2fKuz2Gy"

    response = Api::Spotify.artist("0oSGxfWSnnOXhD2fKuz2Gy")
    response.each do |r|
      Api::Spotify::ARTIST_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to true
  end

  scenario "Artist's albums query should return results" do

    david_bowie_id = "0oSGxfWSnnOXhD2fKuz2Gy"

    response = Api::Spotify.artists_albums(david_bowie_id)
    response.each do |r|
      Api::Spotify::ALBUM_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to true
  end

end
