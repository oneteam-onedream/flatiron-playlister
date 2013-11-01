Sequel.migration do
  up do 
    create_table :voters do
      primary_key :id, :null=>false
      foreign_key :song_id, :songs
      String :ip_address
    end
  end

  down do
    drop_table :voters
  end
end