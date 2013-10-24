class Playlist
  attr_accessor :songs

  def initialize
    @songs = []
  end

  def add_song(spotify_id)
    song = Song.new(spotify_id)
    songs << song
  end

  def remove_song(song)
    songs.delete(song)
  end

  def list
    self.sort
  end

  def sort
    songs.sort_by { |s| s.date_created }
  end
end