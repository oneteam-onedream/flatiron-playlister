class Playlist < Sequel::Model
  one_to_many :songs

  def add_song(spotify_hash)
    Song.create do |s| 
        s.spotify_id  =  spotify_hash[:spotify_id]
         s.song_name  =  spotify_hash[:song_name]
       s.artist_name  =  spotify_hash[:artist_name]
       s.upvoters = []
       s.playlist_id  =  self.id
    end
  end

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
