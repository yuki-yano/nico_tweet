class TweetLogger
  def initialize(file)
    @file = file
    @log = IO.read(file).split("\n")
  end

  def include?(url)
    @log.include? url
  end

  def print(url)
    open(@file, "a").print(url + "\n")
    @log.push url
  end
end
