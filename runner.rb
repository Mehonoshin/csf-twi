require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require './config/db.rb'
require "./lib/logger"
require "./lib/twibot"
require 'psych'
require "time"
require "net/http"


bot = Twibot.new
l = CustomLogger.new
loop do
  puts l.log("Checking for new tweets")
  counter = bot.check_for_new_tweets
  puts l.log("Found #{counter} new tweets")
  puts l.log(bot.print_api_calls_num)
  sleep(60)
end
