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
        rss = rss_parse u
        rss_tweet rss
      end
    else 
      rss = rss_parse @url
      rss_tweet rss
    end
  end

  private
  def rss_parse(url)
    return RSS::Parser.parse(url, true).channel.items.reverse
  end

  def rss_tweet(rss)
    rss.each do |item|
      if !@tweet_logger.include?(item.link)
        url = item.link.split('?').first
        tag = '#' + url.split('/').pop
        @client.update('"' + item.title + '" - ' + url + ' ' + tag + ' が投稿されました')
        @tweet_logger.print(item.link)
      end
    end
  end
end
