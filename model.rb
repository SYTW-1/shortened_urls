require 'dm-core'
require 'dm-migrations'

class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
  property :urlshort, Text
end
