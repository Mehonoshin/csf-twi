require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require './config/db.rb'
require "./lib/logger"
require 'psych'
require "time"

Tweet.all.each do |tweet|
  tweet.feed_id = Feed.where(username: tweet.username).last.id
  puts tweet.username
  puts Feed.where(username: tweet.username).last.id
  puts tweet.feed_id
  tweet.save!
end
