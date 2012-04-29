class Tweet
  include MongoMapper::Document

  key :text, String
  key :username, String
  key :status_id, String

  after_create :inc_feed_counter

  public
    def inc_feed_counter
      Feed.where(username: self.username).first.inc_tweets_counter
    end

  private
end
