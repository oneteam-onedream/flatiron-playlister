class SpotifyController < Sinatra::Base
  configure do
    $logger = Logger.new($stderr)
    $logger.level = Logger::INFO

    $session_callbacks = {
      log_message: lambda do |session, message|
        $logger.info('session (log message)') { message }
      end,

      logged_in: lambda do |session, error|
        $logger.info('session (logged in)') { Spotify::Error.explain(error) }
      end,

      logged_out: lambda do |session|
        $logger.info('session (logged out)') { 'logged out!' }
      end,

      credentials_blob_updated: lambda do |session, blob|
        $logger.info('session (blob)') { blob }
      end
    }

    appkey = IO.read('./lib/spotify/spotify_appkey.key', encoding: "BINARY")

    config = Spotify::SessionConfig.new({
      api_version: Spotify::API_VERSION.to_i,
      application_key: appkey,
      cache_location: ".spotify/",
      settings_location: ".spotify/",
      user_agent: "spotify for ruby",
      callbacks: Spotify::SessionCallbacks.new($session_callbacks),
    })

    $session = SpotifySupport.create_session(config)

    set :credentials, YAML.load(File.read('./spotify_credentials.yml'))
    set :spotify_session, $session

    $search_complete = lambda do |search, userdata|
      $logger.info "running search callback..."
      $logger.info "searching for #{Spotify.search_query(search)}"
    end
      
  end

  get '/spotify/login' do
    Spotify.session_login(
      settings.spotify_session,
      settings.credentials['username'],
      settings.credentials['password'],
      false, nil
    )

    SpotifySupport.poll(settings.spotify_session) do
      Spotify.session_connectionstate(settings.spotify_session) == :logged_in
    end

    "Logged in!"
  end

  get '/spotify' do
    search = Spotify.search_create(
      settings.spotify_session,
      params[:q], 0, 10, 0, 0, 0, 0, 0, 0, :standard,
      $search_complete,
      nil
    )

    SpotifySupport.poll(settings.spotify_session) do
      Spotify.search_is_loaded(search)
    end

    results = {}

    [10, Spotify.search_total_tracks(search)].min.times do |i|
      track = Spotify.search_track(search, i)

      SpotifySupport.poll(settings.spotify_session) do
        Spotify.track_is_loaded(track)
      end

      # This feels odd, but the variable needs to be padded out for the FFI
      # call to fill it correctly.
      uri = 'a' * 64
      link = Spotify.link_create_from_track(track, 0)
      Spotify.link_as_string(link, uri, uri.size)

      # When uri gets filled out, it is "null terminated", we want the part
      # before the null termination - the Spotify link, or uri
      result = {
        "uri" => uri.split(/\0/)[0],
        "song_name" => Spotify.track_name(track),
        "artist_name" => Spotify.artist_name(Spotify.track_artist(track, 0)),
        "album_name" => Spotify.album_name(Spotify.track_album(track))
      }
      results["result_#{i}"] = result
    end
    results.to_json
  end
end