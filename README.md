#rss_tweet

ニコニコの特定のタグ新着動画をツイートするやつ

##install

```
git clone git@github.com:tigberd/rss_tweet.git
cd rss_tweet
bundle install
cp config/template.yml config/hoge.yml
touch log/hoge
vi config/hoge.yml
```

## tweet

```
bundle exec bin/rss_tweet config/hoge.yml
```
