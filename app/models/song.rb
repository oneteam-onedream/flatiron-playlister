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