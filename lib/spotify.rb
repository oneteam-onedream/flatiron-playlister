class Spotify_Finder
  #!/usr/bin/env ruby
  # encoding: utf-8

  # attach_function :search_create, [ Session, UTF8String, :int, :int, :int, :int, :int, :int, :int, :int, :search_type, :search_complete_cb, :userdata ], Search

  require_relative "../lib/example_support"

  #
  # Global callback procs.
  #
  # They are global variables to protect from ever being garbage collected.
  #
  # You must not allow the callbacks to ever be garbage collected, or libspotify
  # will hold information about callbacks that no longer exist, and crash upon
  # calling the first missing callback. This is *very* important!

class FrameReader
  include Enumerable

  def initialize(channels, sample_type, frames_count, frames_ptr)
    @channels = channels
    @sample_type = sample_type
    @size = frames_count * @channels
    @pointer = FFI::Pointer.new(@sample_type, frames_ptr)
  end

  attr_reader :size

  def each
    return enum_for(__method__) unless block_given?

    ffi_read = :"read_#{@sample_type}"

    (0...size).each do |index|
      yield @pointer[index].public_send(ffi_read)
    end
  end
end

#plaything = Plaything.new

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
    end,

    start_playback: proc do |session|
      $logger.debug("session (player)") { "start playback" }
      plaything.play
    end,

    stop_playback: proc do |session|
      $logger.debug("session (player)") { "stop playback" }
      plaything.stop
    end,

    get_audio_buffer_stats: proc do |session, stats|
      stats[:samples] = plaything.queue_size
      stats[:stutter] = plaything.drops
      $logger.debug("session (player)") { "queue size [#{stats[:samples]}, #{stats[:stutter]}]" }
    end,

    music_delivery: proc do |session, format, frames, num_frames|
      if num_frames == 0
        $logger.debug("session (player)") { "music delivery audio discontuity" }
        plaything.stop
        0
      else
        frames = FrameReader.new(format[:channels], format[:sample_type], num_frames, frames)
        consumed_frames = plaything.stream(frames, format.to_h)
        $logger.debug("session (player)") { "music delivery #{consumed_frames} of #{num_frames}" }
        consumed_frames
      end
    end,

    end_of_track: proc do |session|
      $end_of_track = true
      $logger.debug("session (player)") { "end of track" }
      plaything.stop
    end,
  }

  #
  # Main work code.
  #

  # You can read about what these session configuration options do in the
  # libspotify documentation:
  # https://developer.spotify.com/technologies/libspotify/docs/12.1.45/structsp__session__config.html
  config = Spotify::SessionConfig.new({
    api_version: Spotify::API_VERSION.to_i,
    application_key: $appkey,
    cache_location: ".spotify/",
    settings_location: ".spotify/",
    user_agent: "spotify for ruby",
    callbacks: Spotify::SessionCallbacks.new($session_callbacks),
  })

  $logger.info "Creating session."
  $session = Support.create_session(config)

  $logger.info "Created! Logging in."
  Spotify.session_login($session, $username, $password, false, $blob)

  $logger.info "Log in requested. Waiting forever until logged in."
  Support.poll($session) { Spotify.session_connectionstate($session) == :logged_in }

  $logger.info "Logged in as #{Spotify.session_user_name($session)}."

  # This creates a variable that holds a block (just a chunk of code to run)
  # This variable is later passed in to be a "callback" which is just something
  # that runs when something else finishes and decides to "call" it.
  search_complete_cb = lambda do |search, userdata|
    $logger.info "running search callback..."
    $logger.info "searching for #{Spotify.search_query(search)}"
  end

  # The Spotify gem actually exposes the necessary methods through the Spotify module
  # We don't need to manually allocate FFI pointers like I thought - that was only for a special case

  # Create a Spotify::Search object - notice we set the callback to search_complete_cb
  search = Spotify.search_create($session, "Radiohead", 0, 1, 0, 0, 0, 0, 0, 0, :standard, search_complete_cb, nil)
  # Here is something weird - in order to wait for Spotify to return your results
  # and fire your "callback" we have to "wait". We might as well "poll" the service
  # to see if our callback has happened while we wait...
  Support.poll($session) { Spotify.search_is_loaded(search) }
  # Once we get the search back, we can pull out the track
  track = Spotify.search_track(search, 0)
  # Once the track is loaded...
  Support.poll($session) { Spotify.track_is_loaded(track) }
  # Pull out the name of the track
  name = Spotify.track_name(track)
  $logger.info "Found song named: #{name}"

  Spotify.try(:session_player_play, $session, false)
  $logger.info "Now Playing #{name}"
  Spotify.try(:session_player_load, $session, track)
  Spotify.try(:session_player_play, $session, true)
  Support.poll($session) { $end_of_track }
  $logger.info "Finished Playing #{name}"
end