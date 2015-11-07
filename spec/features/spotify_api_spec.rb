require 'spec_helper'

feature "Spotify Api" do

  scenario "Searches query should return results" do

    success = true

    response = Api::Spotify.search("david bowie")
    response.each do |r|
      Api::Spotify::SEARCH_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to eq(true)
  end

  scenario "Album query should return results" do

    heroes_by_david_bowie_id = "3lFioPGhn7x5Y3H3YbPV83"
    success = true

    response = Api::Spotify.album("3lFioPGhn7x5Y3H3YbPV83")
    Api::Spotify::ALBUM_FIELDS.each do |f|
      success = false unless response[f]
    end

    expect(success).to eq(true)
  end

  scenario "Artist query should return results" do

    david_bowie_id = "0oSGxfWSnnOXhD2fKuz2Gy"
    success = true

    response = Api::Spotify.artist("0oSGxfWSnnOXhD2fKuz2Gy")
    Api::Spotify::ARTIST_FIELDS.each do |f|
      success = false unless response[f]
    end

    expect(success).to eq(true)
  end

  scenario "Artist's albums query should return results" do

    david_bowie_id = "0oSGxfWSnnOXhD2fKuz2Gy"
    success = true

    response = Api::Spotify.artists_albums(david_bowie_id)
    puts response
    response.each do |r|
      Api::Spotify::SEARCH_FIELDS.each do |f|
        success = false unless r[f]
      end
    end

    expect(success).to eq(true)
  end

end
