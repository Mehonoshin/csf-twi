# encoding: utf-8
require 'sinatra'
require 'haml'
require 'mongo_mapper'
require './models/feed'
require './models/tweet'
require './config/db.rb'
require './helpers/helpers'
require 'will_paginate'
require 'will_paginate/view_helpers/sinatra'

class Csf < Sinatra::Base
  helpers Csfhelpers
  helpers WillPaginate::Sinatra::Helpers

  before do
    @request = request
  end

  get '/' do
    tweets_timeline
  end

  get '/twiple' do
    @feeds = Feed.sort(:tweets_counter.desc)
    haml :feeds
  end

  get '/best' do
    tweets_timeline(true)
  end

  get '/about' do
    haml :about
  end

  private

  def tweets_timeline(favorite = false)
    @page = params[:page] || "1"
    @tweets = favorite ? Tweet.where(favorite: true).sort(:created_at.desc).paginate(page: params[:page], per_page: 20) : Tweet.sort(:created_at.desc).paginate(page: params[:page], per_page: 20)
    # TODO
    # Хак, только чтобы лейзи лоад отрисовывал сообщение о достижении конца ленты
    if @tweets.size.zero?
      halt 404
    else
      haml :tweets
    end
  end

end

