#nico_tweet

ニコニコの特定のタグ新着動画をツイートするやつ

## Install

```
git clone https://github.com/tigberd/rss_tweet.git
cd rss_tweet
bundle install
cp config/template.yml config/hoge.yml
touch log/hoge
vi config/hoge.yml
```

## Tweet

```
bundle exec bin/rss_tweet config/hoge.yml
```

## Cron

```
*/20  *  *  *  * cd /path/to/file; bundle exec bin/rss_tweet config/hoge.yml
```
