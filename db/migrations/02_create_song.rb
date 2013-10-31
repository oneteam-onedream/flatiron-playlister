Sequel.migration  do
  up do
    create_table :songs do
      primary_key :id
      foreign_key :playlist_id, :playlists
      String :song_name
      String :artist_name
      String :spotify_id
      Integer :length
      DateTime :created_at
      String :album_name
      String :album_cover
      Integer :upvotes, :default => 1
      String :slug
    end
  end

  down do 
    drop_table :songs
  end
end