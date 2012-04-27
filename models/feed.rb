class Feed
  include MongoMapper::Document
  key :tweets_counter, :integer
  key :username, :string
end
