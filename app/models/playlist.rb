class Playlist < Sequel::Model
  one_to_many :songs

  def add_song(spotify_hash)
    song = Song.create do |s| 
      s.spotify_id = spotify_hash[:id]
      s.song_name = spotify_hash[:name]
    end
    self.songs << song
  end

  # def all_songs
  #   Song.where(:playlist_id => self.id).all
  # end 

  def song_sort
    self.songs.sort_by { |song| song.upvotes }.reverse
  end
end


    
  # SONGS = []

  # def self.add_song(spotify_id)
  #   song = Song.new(spotify_id)
  #   song.song_name = spotify_id
  #   SONGS << song
  # end

  # def self.remove_song(song)
  #   SONGS.delete(song)
  # end

  # def self.sort
  #   SONGS.sort_by { |song| song.upvote_count}.reverse
  # end
