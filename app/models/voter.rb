class Voter < Sequel::Model
  many_to_one :song
end