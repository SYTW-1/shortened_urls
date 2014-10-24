configure :production do
	require 'dm-core'
	require 'dm-migrations'
end

class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :uid, String
  property :email, String
  property :url, Text
  property :urlshort, Text
end
