class Song < Sequel::Model
  attr_accessor :upvoters

  def before_create
    @upvoters = ["harrypottter"]
    super
  end

  def before_save
    @slug = self.song_name.gsub(' ',"-")
    super
  end

  def upvote(ip)
    if @upvoters.include?(ip)
      @upvoters.delete(ip)
    else
      @upvoters << ip
    end
    @upvotes = @upvoters.length
    self.update(:upvotes => @upvotes)
  end

end