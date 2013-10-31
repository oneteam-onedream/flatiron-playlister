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