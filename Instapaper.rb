# Instapaper.rb
# Paperadio
#
# Created by Arun Thampi on 11/20/10.
# Copyright 2010 Deepcalm Apps. All rights reserved.

require 'cgi'

class Instapaper
  INSTAPAPER_URL = "http://www.instapaper.com/u"
  INSTAPAPER_LOGIN = "http://www.instapaper.com/user/login"
  
  attr_accessor :stories
  attr_accessor :parent
  attr_accessor :current_story_text
  attr_accessor :current_speaker
  attr_accessor :current_story_index
  
  def initialize
    super
    self.stories = []
    self.current_story_text = nil
    self.current_speaker = nil
    self.current_story_index = 0
  end
  
  def login_with!(username, password)
    request = ASIFormDataRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/user/login"))
    request.setPostValue(username, forKey:"username")
    request.setPostValue(password, forKey:"password")

    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
  end
  
  def fetch_first_page
    request = ASIHTTPRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/u"))

    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
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
    elsif (request.url.absoluteString =~ /http:\/\/www\.instapaper\.com\/text/im)
      if request.responseStatusCode == 200
        # Strip out HTML
        self.current_story_text = (request.responseString.match(/<div.*?story.*?>(.+)<\/div>\s+<div.*?bottom/im))[1].gsub(/<.*?>/, '')
        NSLog("Going to read out story:\n#{self.current_story_text}")
        self.read_story(self.current_story_text)
      else
        NSLog("Got error code: #{request.responseStatusCode}")
      end
    end
    
    self.parent.activity_indicator.stopAnimation(self)
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
  
  def get_individual_story_from(url_or_index)
    url = if (url_or_index.is_a?(Fixnum))
      self.stories[url_or_index.to_i].url
    else
      url_or_index
    end
  
    request = ASIHTTPRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/text?u=#{CGI.escape(url)}"))

    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
  end
  
  def toggle_play_pause
    if self.current_speaker
      if self.current_speaker.isSpeaking
        # enum NSSpeechWordBoundary
        self.current_speaker.pauseSpeakingAtBoundary(1)
      else
        self.current_speaker.continueSpeaking
      end
    else
      self.get_individual_story_from(0)
    end
  end
  
  def next_story
    self.current_story_index = (self.current_story_index + 1) % self.stories.count
    self.get_individual_story_from(self.current_story_index)
  end
  
  def previous_story
    self.current_story_index = (self.current_story_index == 0) ? self.stories.count - 1 : self.current_story_index - 1
    self.get_individual_story_from(self.current_story_index)
  end
  
  def is_speaking?
    self.current_speaker ? self.current_speaker.isSpeaking : false
  end
  
  def current_title
    self.current_story ? self.current_story.title : "Idle"
  end
  
protected
  def collect_stories_from(page)
    page.scan(/<a.*?a>/im).select { |y| y =~ /tableViewCellTitleLink/ }.each do |raw_story|
      match = raw_story.match(/<a.*?href="(.*?)".*?>(.*?)<\/a>/im)
      self.stories << (story = Story.new(:url => match[1], :title => match[2]))
    end
  end
  
  def read_story(story)
    if self.current_speaker
      self.current_speaker.stopSpeaking if self.current_speaker.isSpeaking
      self.current_speaker = nil
    end
    
    self.current_speaker = NSSpeechSynthesizer.alloc.initWithVoice(NSSpeechSynthesizer.defaultVoice)
    self.current_speaker.startSpeakingString(story)
    
    self.parent.togglePlayPauseButtonImage
  end
end