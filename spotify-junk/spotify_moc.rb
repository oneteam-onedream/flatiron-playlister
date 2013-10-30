class Spotify_Finder
  def self.search(query)
    # return the spotify info for the first song
    {
      uri: "uri-#{query}",
      song_name: "song_name-#{query}",
      artist_name: "artist_name-#{query}"
    }
  end

  def self.play(uri)
    p "playing #{uri}"
  end
end