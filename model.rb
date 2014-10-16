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

