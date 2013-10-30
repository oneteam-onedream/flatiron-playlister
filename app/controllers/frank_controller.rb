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

  set :views, File.expand_path('../../views', __FILE__)

    # A quick method to add all our app files to the reloader
  def self.reload_dirs(array)
    array.each do |dir|
      Dir.entries(dir).each do |file|
        next if file.start_with?(".")
        also_reload "./#{dir}/#{file}"
      end
    end
  end
  
  # Methods in controllers that aren't actions (endpoints for our routes)
  # should be made private.
  private_class_method :reload_dirs # This is native Ruby.
  
  # Configure Sinatra to reload directories like models and controllers.

  register Sinatra::Reloader
  reload_dirs ['app/models', 'app/controllers']

  
  List = Playlist.new

  get '/' do
    erb :'index'
  end

  get '/test' do
    "hey"
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
