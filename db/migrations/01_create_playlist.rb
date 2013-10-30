Sequel.migration do
  up do 
    create_table :playlists do
      primary_key :id
    end
  end

  down do
    drop_table :playlists
  end
end