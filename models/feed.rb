class Feed
  include MongoMapper::Document
  many :tweets

  key :tweets_counter, Integer, :default => 0
  key :username, String
  key :followed, Boolean, :default => false
  key :userpic, String

  before_destroy :delete_relative_tweets

  public
    def inc_tweets_counter
      self.tweets_counter += 1
      self.save
    end

    def follow!
      self.followed = true
      self.save
    end

  private
    def delete_relative_tweets
      Tweet.where(username: self.username).each { |t| t.destroy }
    end
end
