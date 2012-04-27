require "twitter"
require "mongo_mapper"
require "./models/feed"
require "./models/tweet"

mongo_uri = 'mongodb://localhost:27017'
db_name = "csf-twi"

MongoMapper.connection = Mongo::Connection.from_uri(mongo_uri)
MongoMapper.database = db_name

usernames = ["stasik_mexx", "antonylancelot"]
usernames.each do |username|
  # if Feed.where(:username => username).first.nil?
    feed = Feed.new
    feed.username = username
    feed.save!
    # puts Twitter.user_timeline(username).first.text
  # end
end

puts Feed.all
