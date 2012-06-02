require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require './config/db.rb'
require "./lib/logger"
require 'psych'
require "time"

Feed.all.each { |feed| feed.destroy }
Tweet.all.each { |tw| tw.destroy }
