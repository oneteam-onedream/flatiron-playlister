# Kill main thread if any other thread dies.
Thread.abort_on_exception = true

# We use a logger to print some information on when things are happening.
$logger = Logger.new($stderr)
$logger.level = Logger::INFO

#
# Some utility.
#

module Support
  module_function

  def logger
    $logger
  end

  # libspotify supports callbacks, but they are not useful for waiting on
  # operations (how they fire can be strange at times, and sometimes they
  # might not fire at all). As a result, polling is the way to go.
  def poll(session)
    until yield
      FFI::MemoryPointer.new(:int) do |ptr|
        Spotify.session_process_events(session, ptr)
      end
      sleep(0.1)
    end
  end

  def search_create(session, query, track_offset, track_count, album_offset, album_count, artist_offset, artist_count, playlist_offset, playlist_count, search_type, callback, user_data)
    FFI::MemoryPointer.new(Spotify::Search) do |ptr|
      Spotify.try(:search_create, session, query, track_offset, track_count, album_offset, album_count, artist_offset, artist_count, playlist_offset, playlist_count, search_type, callback, user_data, ptr)
      return Spotify::Search.new(ptr.read_pointer)
    end
  end

  def create_session(config)
    FFI::MemoryPointer.new(Spotify::Session) do |ptr|
      Spotify.try(:session_create, config, ptr)
      return Spotify::Session.new(ptr.read_pointer)
    end
  end
end

# Load the configuration.
$appkey = IO.read("lib/spotify_appkey.key", encoding: "BINARY")
$username = "davidbella"
$password = "8ntseni9"