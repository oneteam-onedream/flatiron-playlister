class FrankController < ApplicationController
  enable :sessions

  get '/' do
    redirect '/playlist'
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

