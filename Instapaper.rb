# Instapaper.rb
# Paperadio
#
# Created by Arun Thampi on 11/20/10.
# Copyright 2010 Deepcalm Apps. All rights reserved.


class Instapaper
  INSTAPAPER_URL = "http://www.instapaper.com/u"
  INSTAPAPER_LOGIN = "http://www.instapaper.com/user/login"
  
  attr_accessor :stories
  attr_accessor :parent
  
  def initialize
    super
    self.stories = []
  end
  
  def login_with!(username, password)
    request = ASIFormDataRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/user/login"))
    request.setPostValue(username, forKey:"username")
    request.setPostValue(password, forKey:"password")

    request.delegate = self
    request.startAsynchronous
  end
  
  def fetch_first_page
    request = ASIHTTPRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/u"))

    request.delegate = self
    request.startAsynchronous
  end

  def requestFinished(request)
    if (request.url.absoluteString == "http://www.instapaper.com/user/login" &&
        request.responseStatusCode == 200)
      NSLog("Successfully logged in")
      self.fetch_first_page
    elsif (request.url.absoluteString == "http://www.instapaper.com/u" &&
            request.responseStatusCode == 200)
      NSLog("Fetched first page successfully")
      collect_stories_from(request.responseString)
    end
  end
  
  def logout!
    # pending
  end
  
  def has_login_credentials_already?
    instapaper_cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage.cookiesForURL(NSURL.URLWithString("http://www.instapaper.com"))
    instapaper_cookies.size > 0
  end
  
protected
  def collect_stories_from(page)
    page.scan(/<a.*?a>/im).select { |y| y =~ /tableViewCellTitleLink/ }.each do |raw_story|
      match = raw_story.match(/<a.*?href="(.*?)".*?>(.*?)<\/a>/im)
      self.stories << (story = Story.new(:url => match[1], :title => match[2]))
      NSLog("Story: #{story.title} <#{story.url}>")
#      match = raw_story.match(/<a.*?href="(.*?)".*?>(.*?)<\/a>/im)
#      NSLog "Link: #{match[1]} Title: #{match[2]}"
    end
    
#    NSLog("Stories To Fetch: #{stories.count}")
  end
  
end