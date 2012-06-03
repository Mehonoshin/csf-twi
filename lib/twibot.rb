class Twibot

  def initialize
    $api_calls = 0
    @new_tweets = []
    twitter_settings = Psych.load(File.open('config/settings/twitter.yml'))
    Twitter.configure do |config|
      config.consumer_key = twitter_settings['twitter']['consumer_key']
      config.consumer_secret = twitter_settings['twitter']['consumer_secret']
      config.oauth_token = twitter_settings['twitter']['oauth_token']
      config.oauth_token_secret = twitter_settings['twitter']['oauth_token_secret']
    end
  end

  def check_for_new_tweets
    new_tweets_counter = 0
    Twitter.home_timeline.reverse!.each do |tweet|
      if Tweet.where(status_id: tweet.id.to_s).first.nil?
        Tweet.create!(text: tweet.text, status_id: tweet.id.to_s, username: tweet.user.screen_name, created_at: tweet.created_at)
        @new_tweets << tweet
        new_tweets_counter += 1
      end
    end
    $api_calls += 1
    new_tweets_counter
  end

  def print_api_calls_num
    "Total api calls: #{$api_calls}"
  end

  def notify_clients
    @new_tweets.each do |new_tweet|
      message = {tweet: new_tweet.text, username: new_tweet.user.screen_name, userpic: new_tweet.user.profile_image_url, created_at: new_tweet.created_at}
      push_notification(message.to_json)
    end
    @new_tweets = []
  end

  def push_notification(data)
    message = {channel: "/tweets/new", data: data}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

end

