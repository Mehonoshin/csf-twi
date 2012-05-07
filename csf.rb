require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './models/feed'
require './models/tweet'
require './config/db.rb'
require './helpers'
require 'will_paginate'
require 'will_paginate/view_helpers/sinatra'

class Csf < Sinatra::Base
  helpers Csfhelpers
  helpers WillPaginate::Sinatra::Helpers

  before do
    @request = request
  end

  get '/' do
    @page = params[:page] || "1"
    @tweets = Tweet.sort(:created_at.desc).paginate(page: params[:page], per_page: 20)
    if @tweets.size.zero?
      halt 404
    else
      haml :tweets
    end
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
    redirect "/twiple/edit"
  end

end

