Sequel.migration do
  up do 
    create_table :voters do
      primary_key :id
      String :ip_address
      foreign_key :song_id, :songs
    end
  end

  down do
    drop_table :voters
  end
end