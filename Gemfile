source 'https://rubygems.org'

#gem 'alphadecimal'
gem 'data_mapper'
gem 'sinatra-contrib'
gem 'haml'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    gem "sqlite3"
    gem "dm-sqlite-adapter"
end