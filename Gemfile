source 'https://rubygems.org'

#gem 'alphadecimal'
gem 'data_mapper'
gem 'sinatra-contrib'
gem 'haml'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    gem "sqlite3"
    gem "dm-sqlite-adapter"
end