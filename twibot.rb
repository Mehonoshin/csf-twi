require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require "time"

class Twibot

  MONGOURI = 'mongodb://localhost:27017'
  DBNAME = "csf-twi"

  def initialize
    MongoMapper.connection = Mongo::Connection.from_uri(MONGOURI)
    MongoMapper.database = DBNAME
    @feeds = Feed.all
  end

  def check_for_new_tweets
    new_tweets_counter = 0
    @feeds.each do |feed|
      Twitter.user_timeline(feed.username).each do |tweet|
        if Tweet.where(status_id: tweet.id.to_s).first.nil?
          Tweet.create(text: tweet.text, status_id: tweet.id.to_s, username: feed.username, created_at: tweet.created_at)
          new_tweets_counter += 1
        end
      end
    end
    new_tweets_counter
  end

  def do
    Tweet.all.each { |tweet| tweet.destroy }
  end

end

bot = Twibot.new
loop do
  puts "Checking for new tweets"
  counter = bot.check_for_new_tweets
  puts "Found #{counter} new tweets"
  sleep(10)
end
