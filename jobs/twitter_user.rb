#!/usr/bin/env ruby
require 'net/http'
require 'json'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------

twitter_username = ENV['TWITTER_USERNAME'] || 'foobugs'

SCHEDULER.every '2m', :first_in => 0 do |job|
  http = Net::HTTP.new('api.twitter.com')
  response = http.request(Net::HTTP::Get.new("/1/users/show.json?screen_name=#{twitter_username}"))
  followers_count = JSON.parse(response.body)['followers_count']
  
  send_event('twitter_followers', current: followers_count)
  send_event('twitter_following', current: friends_count)
  send_event('twitter_tweets', current: statuses_count)
end
