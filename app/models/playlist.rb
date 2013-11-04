class Playlist < Sequel::Model
  one_to_many :songs

  def added_by_user(user_ip)
    self.songs.collect do |song|
      users_songs ||= []
      users_songs << song if song.creator_ip == user_ip
    end
  end

  def user_limit_met
    :user_limit_met
  end

  def playlist_full?
    self.songs.count > 20
  end

  def playlist_full
    :playlist_full
  end

  def add_song(spotify_hash, user_ip)
    if !self.playlist_full?
      if self.added_by_user(user_ip).length < 4
        Song.create do |s| 
            s.uri  =  spotify_hash["uri"]
             s.song_name  =  spotify_hash["song_name"]
           s.artist_name  =  spotify_hash["artist_name"]
            s.album_name  =  spotify_hash["album_name"]
            s.created_at  = Time.now
           s.playlist_id  =  self.id
            s.creator_ip  =  user_ip
        end
      else
        self.user_limit_met
      end
    else
      playlist_full
    end
  end

  def song_sort
    self.songs.sort_by { |song| song.upvotes }.reverse
  end

  def current_song
    @song = self.song_sort[0]
    # @song.destroy
  end 

  def songs_in_queue
    self.song_sort.reject { |song| song == self.current_song }
  end

  def before_play
    # should have a song to send to spotifiy play
  end

  def after_play
    # should take the first song in the sorted list send to before_play
  end
end