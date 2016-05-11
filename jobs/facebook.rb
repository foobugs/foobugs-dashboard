require 'koala'

def facebook_posts(page_name)
  posts = @graph.get_connections(page_name, 'tagged',
                                 {fields: ['message', 'from', 'picture', 'icon']},
                                 {:use_ssl => true})
  formatted_posts(posts[0..9])
end

def graph_client(token, secret)
  Koala::Facebook::API.new(token, secret)
end

def formatted_posts(posts)
  posts.each_with_object([]) do |post, arr|
    arr << {
      name: post['from']['name'],
      body: post['message'] == "" ? "–" : post['message'],
      avatar: post['picture'] || post['icon']
    }
  end
end

def page_info(page_name)
  info = @graph.get_object(page_name,
                           {fields: ['likes', 'checkins', 'talking_about_count']},
                           {:use_ssl => true})
  {
    likes: info['likes'],
    checkins: info['checkins'],
    talking_about: info['talking_about_count']
  }
end

# Your page name (see graph.facebook.com/YOUR_PAGE_NAME)
page_name = ''
# Your access token
access_token = ''
# Your app secret
app_secret = ''

SCHEDULER.every '1m', :first_in => 0 do
  @graph = Koala::Facebook::API.new(access_token, app_secret)
  send_event('facebook_posts', {page_info: page_info(page_name), comments: facebook_posts(page_name)})
end
