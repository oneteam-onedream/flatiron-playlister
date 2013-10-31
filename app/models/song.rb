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

  def vote
    self.update(:upvotes => self.upvotes += 1)
  end
end