class PlaylistController < ApplicationController
  enable :sessions

  # def upvote_or_unvote(song, ip)
  #   if session[:song_votes].keys.include?(song.id)
  #     if session[:song_votes][song.id].include?(ip)
  #       song.unvote
  #       session[:song_votes][song.id].delete(ip)
  #     else
  #       song.upvote
  #       session[:song_votes][song.id] << ip
  #     end
  #   end
  # end

  get '/' do
    Playlist.create
    redirect '/playlist'
    #session[:song_votes] = {}
  end

  get '/spotify' do
    @queries = Spotify_Finder.search(params[:search])
    session[:queries] = @queries
    redirect '/playlist'
  end

  post '/playlist/add' do
    @song = Playlist[1].add_song(params[:song], request.ip)
    if @song == :user_limit_met
      redirect '/playlist/user_limit'
    elsif @song == :playlist_full
      redirect '/playlist/full'
    end
    session[:queries] = nil
    redirect '/playlist'
  end

  get '/playlist/user_limit' do
    erb :user_limit
  end

  get '/playlist/full' do
    erb :playlist_full
  end

  get '/playlist' do 
    @queries = session[:queries]
    @playlist = Playlist[1]
    @current_song = @playlist.current_song
    @songs = @playlist.songs_in_queue
    erb :'playlist'
  end

  get '/songs/:slug/upvote' do
    @song = Playlist[1].songs.detect {|song| song.slug == params[:slug]}
    @song.vote(request.ip)
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