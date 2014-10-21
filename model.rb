class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :uid, String
  property :url, Text
  property :urlshort, Text
end

