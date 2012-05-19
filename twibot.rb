require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require './config/db.rb'
require "./lib/logger"
require 'psych'
require "time"

class Twibot

  def initialize
    @api_calls = 0
    twitter_settings = Psych.load(File.open('config/settings/twitter.yml'))
    Twitter.configure do |config|
      config.consumer_key = twitter_settings['twitter']['consumer_key']
      config.consumer_secret = twitter_settings['twitter']['consumer_secret']
      config.oauth_token = twitter_settings['twitter']['oauth_token']
      config.oauth_token_secret = twitter_settings['twitter']['oauth_token_secret']
    end
    update_feeds
  end

  def update_feeds
    Feed.where(followed: false).each do |feed|
      if Twitter.follow(feed.username)
        feed.follow!
        @api_calls += 1
      end
    end
  end

  def check_for_new_tweets
    new_tweets_counter = 0
    Twitter.home_timeline.each do |tweet|
      if Tweet.where(status_id: tweet.id.to_s).first.nil?
        Tweet.create(text: tweet.text, status_id: tweet.id.to_s, username: tweet.user.screen_name, created_at: tweet.created_at)
        new_tweets_counter += 1
      end
    end
    @api_calls += 1
    new_tweets_counter
  end

  def print_api_calls_num
    "Total api calls: #{@api_calls}"
  end

end

bot = Twibot.new
l = CustomLogger.new
loop do
  puts l.log("Checking for new tweets")
  counter = bot.check_for_new_tweets
  puts l.log("Found #{counter} new tweets")
  bot.update_feeds
  puts l.log(bot.print_api_calls_num)
  sleep(60)
end
