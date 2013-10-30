class Playlist
    
  SONGS = []

  def self.add_song(spotify_id)
    song = Song.new(spotify_id)
    song.song_name = spotify_id
    SONGS << song
  end

  def self.remove_song(song)
    SONGS.delete(song)
  end

  def self.sort
    SONGS.sort_by { |song| song.upvote_count}.reverse
  end
end