USERNAME = 'davidbella'
PASSWORD = 'oneteam-onedr3am'

require_relative '../config/environment'
require 'pp'

SpotifyWeb.run do
  client = SpotifyWeb::Client.new(USERNAME, PASSWORD)

  results = client.search('Radiohead', :only => :songs, :limit => 1)

  results.each do |key, value|
    pp "#{key}: #{value}"
  end
end