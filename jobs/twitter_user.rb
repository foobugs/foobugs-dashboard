#!/usr/bin/env ruby
require 'twitter'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------

twitter_username = ENV['TWITTER_USERNAME'] || 'foobugs'

Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

twitter_username = ENV['TWITTER_USERNAME'] || 'foobugs'

SCHEDULER.every '2m', :first_in => 0 do |job|
  
  send_event('twitter_followers', current: Twitter.user(twitter_username).followers_count)
  send_event('twitter_following', current: Twitter.user(twitter_username).friends_count)
  send_event('twitter_tweets',    current: Twitter.user(twitter_username).statuses_count)
end
