#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'data_mapper'
require 'pp'

require 'socket'

DataMapper.setup( :default, ENV['DATABASE_URL'] || 
                            "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
end

DataMapper.finalize
require  'dm-migrations'

# This will issue the necessary CREATE statements (DROPing the table
#first, if it exists) to define each storage according to their
#properties.
# After auto_migrate! has been run, the database should be in a pristine state.
# All the tables will be empty and match the model definitions.
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!
#set :address, address # 'http://localhost:9292'

get '/' do
  puts "inside get '/': #{params}"
  @list = ShortenedUrl.all(:order => [ :id.desc ], :limit => 20)
  haml :index
end

post '/' do
  puts "inside post '/': #{params}"
  uri = URI::parse(params[:url])
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    begin
      @short_url = ShortenedUrl.create(:url => params[:url])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  redirect '/'
end

get '/:shortened' do
  puts "inside get '/:shortened': #{params}"
  short_url = ShortenedUrl.first(:id => params[:shortened])

  # HTTP status codes that start with 3 (such as 301, 302) tell the
  # browser to go look for that resource in another location. This is
  # used in the case where a web page has moved to another location or
  # is no longer at the original location. The two most commonly used
  # redirection status codes are 301 Move Permanently and 302 Found.
  redirect short_url.url, 301
end

error do haml :index end
