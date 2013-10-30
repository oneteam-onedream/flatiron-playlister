
class Song
  attr_accessor :song_name, :artist_name, :spotify_id, :length, :date_created, :album_cover, :album_name, :upvoters
  attr_reader :slug

  def initialize(spotify_id)
    @spotify_id = spotify_id
    @upvoters = ["harrypottter"]
    @date_created = Time.now
  end

  def song_name=(song_name)
    @song_name = song_name
    @slug= song_name.downcase.gsub(" ", "-")
    p @slug
  end

  def upvote(ip)
    if @upvoters.include?(ip)
      @upvoters.delete(ip)
    else
      @upvoters << ip
    end
    @upvoters
  end

  def upvote_count
    @upvoters.length
  end  
end