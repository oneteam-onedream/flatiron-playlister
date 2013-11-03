require_relative '../config/environment'
require 'pp'

# Loads a file in the root directory with YAML format, example:
# username: davidbella
# password: whatever-my-password-is
credentials = YAML.load(File.read('./spotify_credentials.yml'))

USER_AGENT = 'node-spotify-web (Chrome/13.37 compatible-ish)'
USERNAME = credentials['username']
PASSWORD = credentials['password']

# SpotifyWeb also uses EventMachine - this creates an EM "loop" to run stuff
SpotifyWeb.run do
  # Create a client and log in
  client = SpotifyWeb::Client.new(USERNAME, PASSWORD)

  # How easy it is to search!
  results = client.search('Radiohead', :only => :songs, :limit => 1)

  # For each result (only 1) let's play it!
  results.each do |track|
    pp "Title: #{track.title}, URI: #{track.uri}, ID: #{track.id}"

    new_song = SpotifyWeb::Song.new(client, {:id => track.id})
    pp new_song

    new_song.load

    pp new_song

    puts track.inspect

    track.load

    puts track.inspect

    # Not as easy... we have to send some well-crafted messages to Spotify
    args = ["mp3160", Radix::Base.new(Radix::BASE::HEX).encode(track.gid).rjust(32, '0')]

    # Luckily the gem exposes the client's "api" method to send messages
    # We are telling Spotify to give us some additional information
    # about the track we got as a result from line 19's search
    uri_result = client.api('sp/track_uri', args)
    pp uri_result

    # The "lid" is super important, it's like a specific instance of the song
    lid = uri_result["result"]["lid"]
    # The "uri" here isn't the regular Spotify URI we are used to
    # This one actually points to a CloudFront address with the actual
    # mp3 file!!! What? Awesome!
    uri = uri_result["result"]["uri"]

    # Trying to get a response from that site gives us AccessDenied!
    # I assume it is because I am locked out of Spotify right now
    request = EventMachine::HttpRequest.new(uri)
    response = request.get#(:head => {'User-Agent' => USER_AGENT})

    p response
    # response.stream { |chunk| print chunk }

    # We have to tell Spotify we have begun playing (3 means play)
    args = [lid, 3, 0]
    client.api('sp/track_event', args)

    # Let's go ahead and tell the track we are done playing
    ms_played = track.length
    ms_played_union = track.length
    n_seeks_forward = 0
    n_seeks_backward = 0
    ms_seeks_forward = 0
    ms_seeks_backward = 0
    ms_latency = 100
    display_track = ""
    play_context = 'unknown'
    source_start = 'unknown'
    source_end = 'unknown'
    reason_start = 'unknown'
    reason_end = 'unknown'
    referrer = 'unknown'
    referrer_version = 'unknown'
    referrer_vendor = 'unknown'
    max_continuous = track.length
    unknown1 = "none"
    unknown2 = "na"

    args = [
      lid,
      ms_played,
      ms_played_union,
      n_seeks_forward,
      n_seeks_backward,
      ms_seeks_forward,
      ms_seeks_backward,
      ms_latency,
      display_track,
      play_context,
      source_start,
      source_end,
      reason_start,
      reason_end,
      referrer,
      referrer_version,
      referrer_vendor,
      max_continuous,
      unknown1,
      unknown2
    ]

    client.api('sp/track_end', args)
  end
end