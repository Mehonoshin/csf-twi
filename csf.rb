require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './models/feed'
require './models/tweet'
require './config/db.rb'

require './helpers'

PERPAGE = 15

before do
  @request = request
end

get '/' do
  page = params[:page]
  @tweets = Tweet.paginate({order: :status_id.asc, per_page: PERPAGE, page: page})
  @total_tweets = Tweet.all.count
  haml :tweets
end

get '/twiple' do
  @feeds = Feed.all
  haml :feeds
end
