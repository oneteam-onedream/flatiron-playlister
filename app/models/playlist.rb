class Playlist < Sequel::Model
  one_to_many :songs

  def add_song(spotify_hash)
    Song.create do |s| 
        s.spotify_id  =  spotify_hash[:spotify_id]
         s.song_name  =  spotify_hash[:song_name]
       s.artist_name  =  spotify_hash[:artist_name]
       s.playlist_id  =  self.id
    end
  end

  def song_sort
    self.songs.sort_by { |song| song.upvotes }.reverse
  end

  def before_play
    if song_sort.length > 0
      song = self.song_sort[0]
      song_name = song.song_name
      self.songs.delete(song)
      return [song_name, self.start_time]
    end
  end

  # def start_time
  #   @start_time = Time.now
  # end

  # def time_span(start)
  #   if Time.now - start > 1
  #     self.after_play
  #   end
  # end

  def after_play
    song.voters.each { |voter| voter.destroy }
    song.destroy
    self.before_play
  end
end