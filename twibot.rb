require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"

class Twibot

  MONGOURI = 'mongodb://localhost:27017'
  DBNAME = "csf-twi"

  def initialize
    MongoMapper.connection = Mongo::Connection.from_uri(MONGOURI)
    MongoMapper.database = DBNAME
    @feeds = Feed.all
  end

  def check_for_new_tweets
    @feeds.each do |feed|
      Twitter.user_timeline(feed.username).each do |tweet|
        if Tweet.where(status_id: tweet.id.to_s).first.nil?
          Tweet.create(text: tweet.text, status_id: tweet.id.to_s, username: feed.username)
        end
      end
    end
  end

end

# Twibot.new.check_for_new_tweets
# Tweet.all.each { |state| puts tweet.text }
# puts Status.first.to_json

# def add_users
#   usernames = ["stasik_mexx", "antonylancelot"]
#   usernames.each do |username|
#     if Feed.where(username: username).first.nil?
#       feed = Feed.create!(username: username)
#     end
#   end
# end

# def list_users
#   Feed.all.each do |user|
#     puts user.username
#   end
# end

# def check_for_new_tweets
#   Twitter.user_timeline("stasik_mexx").each do |tweet|
#     puts tweet.to_hash
#   end
# end

# def clear_feeds_list
#   Feed.all.each { |user| user.destroy }
# end

# add_users
# list_users
# check_for_new_tweets
# clear_feeds_list
#
