require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"
require './config/db.rb'
require "./lib/logger"
require 'psych'
require "time"

Feed.where(userpic: nil).each do |feed|
  puts "#{feed.username} has no userpic"
  feed.set_userpic!
end

