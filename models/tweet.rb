class Tweet
  include MongoMapper::Document
  belongs_to :feed

  key :text, String
  key :username, String
  key :status_id, String
  key :created_at, Time
  key :favorite, Boolean
  key :feed_id

  before_create :sanitize_tweet, :replace_links
  after_create :create_feed_if_new, :inc_feed_counter

  public
    def create_feed_if_new
      if feed.nil?
        tweet_feed = Feed.where(username: self.username).first || Feed.create!(username: self.username)
        self.feed_id = tweet_feed.id
        self.save
      end
    end

    def inc_feed_counter
      Feed.where(username: self.username).last.inc_tweets_counter
    end

  private
    def sanitize_tweet
      self.text = text.gsub(%r{</?[^>]+?>}, '')
    end

    def replace_links
      self.text = text.gsub(/http:\/\/[a-z0-9A-Z.\/]+/) { |m| "<a href='#{m}' target='blank'>#{m}</a>" }
      self.text = text.gsub(/@[a-zA-Z0-9_-]+/) { |m| "<a href='http://twitter.com/#{m.delete("@")}' target='blank'>#{m}</a>" }
    end

end
