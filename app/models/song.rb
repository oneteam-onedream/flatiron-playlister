class Song
  attr_accessor :upvoters

  def initialize
    @upvoters = ["harrypottter"]
  end

  def before_save
    @slug = @name.gsub(' ',"-")
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