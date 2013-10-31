class Song < Sequel::Model
  many_to_one :playlist
  attr_accessor :upvoters

  def slugify!
    self.slug = self.song_name.downcase.gsub(' ','-')
  end

  def before_save
    self.slugify!
    super
  end

  def upvote
    self.update(:upvotes => self.upvotes += 1)
  end

  def unvote
    self.update(:upvotes => self.upvotes -= 1)
  end
end