source 'https://rubygems.org'

#gem 'alphadecimal'

gem 'data_mapper'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'haml'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'pry' 
gem 'erubis'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development do
    gem "sqlite3"
    gem "dm-sqlite-adapter"
end

group :test do
	gem "sqlite3"
	gem "dm-sqlite-adapter"
    gem "rack-test"
    gem "rake"
end