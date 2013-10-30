class Spotify_Finder
  def self.search(query)
    # return the spotify info for the first song
    {
      song_name: "uri-#{query}",
      artist_name: "artist_name-#{query}"
    }
  end

  def self.play(uri)
    p "playing #{uri}"
  end
end