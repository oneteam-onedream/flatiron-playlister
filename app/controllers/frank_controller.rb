class FrankController < ApplicationController
  enable :sessions

  get '/' do
    redirect '/playlist'
  end

  get '/master' do
    
  end

  get '/spotify' do
    @query = Spotify_Finder.search(params[:search])
    session[:query] = @query
    redirect '/playlist'
  end

  get '/playlist/add/:uri' do
    Playlist.add_song(params[:uri])
    session[:query] = nil
    redirect '/playlist'
  end

  get '/playlist' do 
    @query = session[:query]
    erb :'playlist'
  end

  get '/songs/:slug/upvote' do
    @song = Playlist::SONGS.detect {|song| song.slug == params[:slug]}
    @song.upvote(request.ip)
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