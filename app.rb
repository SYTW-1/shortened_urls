#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

enable :sessions
set :session_secret, '*&(^#234a)'

configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

Base = 36


get '/' do
  if !session[:uid]
    puts "inside get '/': #{params}"
    @list = ShortenedUrl.all(:order => [ :id.desc ], :limit => 20)
    # in SQL => SELECT * FROM "ShortenedUrl" ORDER BY "id" ASC
    haml :index
  else
    redirect '/session'
  end
end

get '/auth/:name/callback' do
  @auth = request.env['omniauth.auth']
  session[:uid] = @auth['uid'];
  session[:name] = @auth['info'].first_name
  session[:email] = @auth['info'].email
  @list = ShortenedUrl.all(:uid => session[:uid])
  haml :user
end

get '/session' do
  @list = ShortenedUrl.all(:uid => session[:uid])
  haml :user
end
get '/logout' do
  session.clear
  redirect 'https://www.google.com/accounts/Logout?continue=https://appengine.google.com/_ah/logout?continue=' + to('/')
end

#get '/delete' do
#  ShortenedUrl.all.destroy
#  redirect '/'
#end

post '/' do
  puts "inside post '/': #{params}"
  uri = URI::parse(params[:url])
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    begin
      @short_url = ShortenedUrl.first_or_create(:uid => session[:uid], :email => session[:email], :url => params[:url], :urlshort => params[:urlshort])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  if !session[:uid]
    redirect '/'
  else
    redirect 'session'
  end
end

get '/:shortened' do
  puts "inside get '/:shortened': #{params}"
  short_url = ShortenedUrl.first(:urlshort => params[:shortened])

  # HTTP status codes that start with 3 (such as 301, 302) tell the
  # browser to go look for that resource in another location. This is
  # used in the case where a web page has moved to another location or
  # is no longer at the original location. The two most commonly used
  # redirection status codes are 301 Move Permanently and 302 Found.
  redirect short_url.url, 301
end

error do haml :index end
