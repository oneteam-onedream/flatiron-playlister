require_relative './env.rb'
class Song
  attr_accessor :song_name, :artist_name, :spotify_id, :length, :date_created, :album_cover, :album_name

  def initialize(spotify_id)
    @spotify_id = spotify_id
    @date_created = Time.now
  end

end