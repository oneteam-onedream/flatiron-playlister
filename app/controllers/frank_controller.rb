class FrankController < ApplicationController

  get '/' do
    redirect '/playlist'
  end

  get '/spotify' do
    # pass search query to spotify api
    @query = Spotify_Finder.search(params[:search])
    erb :'results'
    # Song.new(@query)
  end

  get '/playlist/add/:uri' do
    Playlist.add_song(params[:uri])
    redirect '/playlist'
  end

  get '/playlist' do 
    erb :'playlist'
  end

  get '/songs/:slug/upvote' do
    @song = Playlist::SONGS.detect {|song| song.slug == params[:slug]}
    @song.upvote(request.ip)
    redirect '/playlist'
  end

end

