class PlaylistController < ApplicationController
  enable :sessions

  get '/' do
    redirect '/playlist'
  end

  get '/spotify' do
    @query = Spotify_Finder.search(params[:search])
    session[:query] = @query
    redirect '/playlist'
  end

  post '/playlist/add' do
    Playlist[1].add_song(params[:song])
    # binding.pry
    session[:query] = nil
    redirect '/playlist'
  end

  get '/playlist' do 
    @query = session[:query]
    @playlist = Playlist[1]
    @songs = @playlist.song_sort
    erb :'playlist'
  end

  get '/songs/:slug/upvote' do
    @song = Playlist[1].songs.detect {|song| song.slug == params[:slug]}
    binding.pry
    @song.upvote(request.ip)
    # session[:song_votes] = {@song.slug=>[request.ip]}
    redirect '/playlist'
  end

end

# HEROKU OR RASPBERRY PI

# master page
#   -master user creates 'room' with name and password
#   -teather to spotify login
#   -master streams songs
#   -has user page functionality

# user page



# duplication!
# Spotify functionality
# AJAX
#   -search results
#   -list sorting by vote count
#   -
# Where to play the song?
#   -adding to database with after_play callback
#   -removing song from list with after_play callback
# CSS/ page design
# archive/ history page?
# server/ database