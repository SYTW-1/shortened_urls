ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require_relative '../app.rb'


include Rack::Test::Methods

def app
	Sinatra::Application
end

configure :test do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative '../model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

describe "shortened urls" do

end