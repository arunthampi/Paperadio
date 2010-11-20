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

      self.collect_stories_from(request.responseString)
      self.set_stories_index_html
    end
  end
  
  def logout!
    # pending
  end
  
  def has_login_credentials_already?
    instapaper_cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage.cookiesForURL(NSURL.URLWithString("http://www.instapaper.com"))
    instapaper_cookies.size > 0
  end
  
  def set_stories_index_html
    page = """
      <html>
        <head>
        <style type='text/css'>
            #body {
              width: 100%
              background-color: #D2D2D2;
            }
            
            .instapaper_story {
              font:16px/1.5 Helvetica Neue,Arial,Helvetica,'Liberation Sans',FreeSans,sans-serif;
              
              padding-left: 0.5px;
              padding-top: 5px;
              padding-bottom: 5px;
              position:relative;
              margin-top: 10px;
              
              display: block;
              
              border-radius: 15px;
              min-height: 20px;
              color: #444444;
              background-color: #F2F2F2;
            }
            
            .instapaper_story:hover {
              background-color: #4d7fe8;
              cursor: pointer;
              color: #ffffff;
            }
            
            .instapaper_story p {
              margin: 10px;
            }
            
          </style>
        </head>
        
        <body>
          <div id='body'>
            STORIES_BODY
          </div>
        </body>
      </html>
    """

    stories_html = ""

    self.stories.each_with_index do |story, index|
      stories_html << "<div class='instapaper_story' onclick=\"location.href='http://paperadio.local/stories/#{index}'\"><p>#{story.title}</p></div>\n"
    end
    
    page = page.gsub(/STORIES_BODY/, stories_html)
    parent.web_view.mainFrame.loadHTMLString(page, baseURL:NSURL.URLWithString("http://paperadio.local"))
  end
  
protected
  def collect_stories_from(page)
    page.scan(/<a.*?a>/im).select { |y| y =~ /tableViewCellTitleLink/ }.each do |raw_story|
      match = raw_story.match(/<a.*?href="(.*?)".*?>(.*?)<\/a>/im)
      self.stories << (story = Story.new(:url => match[1], :title => match[2]))
    end
  end
  
end