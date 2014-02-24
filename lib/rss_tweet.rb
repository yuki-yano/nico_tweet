require 'twitter'
require 'open-uri'
require 'rss'
require 'tweet_logger'

class RssTweet
  def initialize(config, tweet_logger)
    @client = Twitter::REST::Client.new do |conf|
      conf.consumer_key       = config['twitter']['consumer_key']
      conf.consumer_secret    = config['twitter']['consumer_secret']
      conf.oauth_token        = config['twitter']['oauth_token']
      conf.oauth_token_secret = config['twitter']['oauth_token_secret']
    end

    @url = config['url']
    @tweet_logger = tweet_logger
  end

  def tweet
    if @url.kind_of?(Array)
      @url.each do |u|
        rss = parse_rss u
        tweet_rss rss
      end
    else
      rss = parse_rss @url
      tweet_rss rss
    end
  end

  private
  def parse_rss(url)
    return RSS::Parser.parse(url, true).channel.items.reverse
  end

  def tweet_rss(rss)
    rss.each do |item|
      url = item.link.split('?').first
      if !@tweet_logger.include?(url)
        tag = '#' + url.split('/').pop
        @client.update('"' + item.title + '" - ' + url + ' ' + tag + ' が投稿されました')
        @tweet_logger.print(url)
      end
    end
  end
end
