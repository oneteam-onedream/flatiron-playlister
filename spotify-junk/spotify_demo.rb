require_relative '../config/environment'
require 'pp'

# Loads a file in the root directory with YAML format, example:
# username: davidbella
# password: whatever-my-password-is
credentials = YAML.load(File.read('./spotify_credentials.yml'))

USER_AGENT = 'ruby-spotify-web (Chrome/13.37 compatible-ish)'
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

    # Not as easy... we have to send some well-crafted messages to Spotify
    args = ["mp3160", track.id]

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

    # We have to tell Spotify we have begun playing (3 means play)
    args = [lid, 3, 0]
    client.api('sp/track_event', args)

    # Trying to get a response from that site gives us AccessDenied!
    # I assume it is because I am locked out of Spotify right now
    request = EventMachine::HttpRequest.new(uri)
    response = request.get(:head => {'User-Agent' => USER_AGENT})

    p response
  end
end