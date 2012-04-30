require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './models/feed'
require './models/tweet'
require './config/db.rb'
require './helpers'

class Csf < Sinatra::Base

  PERPAGE = 15

  before do
    @request = request
  end

  get '/' do
    @page = params[:page] || "1"
    @tweets = Tweet.paginate({order: :created_at.desc, per_page: PERPAGE, page: @page})
    @total_tweets = Tweet.all.count
    haml :tweets
  end

  get '/twiple' do
    @feeds = Feed.all
    haml :feeds
  end

  get '/twiple/edit' do
    @feeds = Feed.all
    haml :edit_feeds
  end

  # TODO: Костыль, переделать, чтобы удаление было через метод DELETE
  get '/twiple/:username' do
    Feed.where(username: params[:username]).first.destroy
    redirect '/twiple/edit'
  end

  post '/add' do
    username = params[:username]
    username = username.gsub("http://twitter.com/", "")
    username = username.gsub("http://twitter.com/\#!/", "")
    username = username.gsub("https://twitter.com/", "")
    username = username.gsub("https://twitter.com/\#!/", "")

    Feed.create!(username: username)
    redirect "/twiple"
  end

end

