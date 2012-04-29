require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './models/feed'
require './models/tweet'
require './config/db.rb'

require './helpers'

before do
  @request = request
end

get '/' do
  @tweets = Tweet.all
  haml :tweets
end

get '/twiple' do
  @feeds = Feed.all
  haml :feeds
end
