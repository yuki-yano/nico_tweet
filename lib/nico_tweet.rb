require 'twitter'
require 'open-uri'
require 'rss'
require 'tweet_logger'
require 'uri'
require 'net/http'

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
        text = "\"#{item.title}\" - #{url} #{tag} が投稿されました"
        # Net::HTTP.get(URI.parse("https://slack.com/api/chat.postMessage?token=#{ENV['SLACK_TOKEN']}&channel=%23videos&text=#{URI.escape(text)}&pretty=1&username=bot&link_names=1"))
        @client.update(text)
        @tweet_logger.print(url)
      end
    end
  end

  def parse_rss(url)
    RSS::Parser.parse(url, true).channel.items.reverse
  end
end
