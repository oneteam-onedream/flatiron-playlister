class App < Sinatra::Base
  get '/' do
    erb :'index'
  end

  get '/spotify' do
    # pass search query to spotify app
  end
end
