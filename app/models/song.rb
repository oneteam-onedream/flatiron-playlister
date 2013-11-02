class Song < Sequel::Model
  many_to_one :playlist
  one_to_many :voters

  def slugify!
    self.slug = self.song_name.downcase.gsub(' ','-')
  end

  def before_save
    self.slugify!
    super
  end

  # def add_or_remove(ip)
  #   if Voter.find(:ip => ip)
  #     Voter.find(:ip => ip).destroy
  #   else 
  #     self.voters << Voter.create{ |v| v.ip_address = ip }
  #   end
  # end

  def vote(ip)
    if Voter.find(ip_address: ip, song_id: self.id) 
      Voter.find(ip_address: ip, song_id: self.id).destroy
    else
      Voter.create do |v| 
        v.ip_address = ip
        v.song_id = self.id
      end
    end
    self.update(upvotes: self.voters.uniq.length)
  end
end