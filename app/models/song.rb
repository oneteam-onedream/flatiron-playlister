class Song < Sequel::Model
  many_to_one :playlist
  attr_accessor :upvoters

  # def initialize
  #   @upvoters = ["harrypottter"]
  #   super
  # end

  def slugify!
    self.slug = self.song_name.downcase.gsub(' ','-')
  end

  def before_save
    # self.upvotes = @upvoters.length
    self.slugify!
    super
  end

  # def upvote(ip)
  #   binding.pry
  #     if @upvoters.include?(ip)
  #       @upvoters.delete(ip)
  #     else
  #       @upvoters << ip
  #     end
  #     @upvotes = @upvoters.length
  #   end
  # end
end