class TweetLogger
  def initialize(file)
    @file = file
    @log = IO.read(file).split("\n")
  end

  def include?(url)
    return @log.include?(url)
  end

  def print(link)
    open(@file, "a").print(link + "\n")
  end
end
