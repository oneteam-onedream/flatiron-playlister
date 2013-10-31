class Song < Sequel::Model
  many_to_one :playlist
  attr_accessor :upvoters

  # def before_create
  #   @upvoters = []
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

  # def not_voted?(session)
  #   if session
  #     !session.include?(request.ip)
  #   else 
  #     true
  #   end
  # end

  def upvote(ip)
      if @upvoters.include?(ip)
        @upvoters.delete(ip)
      else
        @upvoters << ip
      end
      # if not_voted?(session)
        self.update(:upvotes => self.upvotes += @upvoters.length)
      # end
  end
end