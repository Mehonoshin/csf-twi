class Feed
  include MongoMapper::Document

  key :tweets_counter, Integer, :default => 0
  key :username, String

  public
    def inc_tweets_counter
      self.tweets_counter += 1
      self.save
    end

  private
end
