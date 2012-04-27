class Tweet
  include MongoMapper::Document
  key :text, :string
  key :username, :string
  key :status_id, :string
end
