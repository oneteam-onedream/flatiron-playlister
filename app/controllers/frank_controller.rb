require 'pry'
require_relative './lib/playlist'
require_relative './lib/song'

class Spotify_Finder
  def self.search(query)
    # return the spotify info for the first song
    {
      uri: "uri-#{query}",
      song_name: "song_name-#{query}",
      artist_name: "artist_name-#{query}"
    }
  end

  def self.play(uri)
    p "playing #{uri}"
  end
end

class App < Sinatra::Base
  List = Playlist.new

  get '/' do
    erb :'index'
  end

  get '/spotify' do
    # pass search query to spotify api
    @query = Spotify_Finder.search(params[:search])
    erb :'results'
    # Song.new(@query)
  end

  get '/playlist/add/:uri' do
    List.add_song(params[:uri])
    erb :'playlist'
  end
end
