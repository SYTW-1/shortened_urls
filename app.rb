#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'data_mapper'
require 'pp'

DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
end

DataMapper.finalize
require  'dm-migrations'

DataMapper.auto_migrate!
DataMapper.auto_upgrade!
set :address, 'http://localhost:4567'

get '/' do
  puts "inside get '/': #{params}"
  @list = ShortenedUrl.all(:order => [ :id.desc ], :limit => 20)
  haml :index, :locals => { :address => settings.address }
end

post '/' do
  puts "inside post '/': #{params}"
  begin
    @short_url = ShortenedUrl.create(:url => params[:url])
  rescue Exception => e
    puts "EXCEPTION!!!!!!!!!!!!!!!!"
    pp @short_url
    puts e.message
  end
  redirect '/'
  #haml :success
end

get '/:shortened' do
  puts "inside get '/:shortened': #{params}"
  short_url = ShortenedUrl.first(:id => params[:shortened])
  redirect short_url.url
end
