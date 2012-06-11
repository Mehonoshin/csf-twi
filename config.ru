require 'bundler'
Bundler.setup :default
require './csf'
require 'sprockets'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/javascripts'
  environment.append_path 'assets/stylesheets'
  run environment
end

map '/' do
  run Csf
end
