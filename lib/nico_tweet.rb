require 'twitter'
require 'open-uri'
require 'rss'
require 'tweet_logger'

class NicoTweet
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
      @url.each {|u| tweet_rss u}
    else
      tweet_rss @url
    end
  end

  private
  def tweet_rss(url)
    parse_rss(url).each do |item|
      url = item.link.split('?').first
      tag = '#' + url.split('/').pop
      unless @tweet_logger.include?(url)
        @client.update('"' + item.title + '" - ' + url + ' ' + tag + ' が投稿されました')
        @tweet_logger.print(url)
      end
    end
  end

  def parse_rss(url)
    RSS::Parser.parse(url, true).channel.items.reverse
  end
end
