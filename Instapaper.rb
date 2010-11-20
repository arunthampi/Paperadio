# Instapaper.rb
# Paperadio
#
# Created by Arun Thampi on 11/20/10.
# Copyright 2010 Deepcalm Apps. All rights reserved.


class Instapaper
  INSTAPAPER_URL = "http://www.instapaper.com/u"
  INSTAPAPER_LOGIN = "http://www.instapaper.com/user/login"
  
  attr_accessor :connection
  
  def initialize
    super
  end
  
  def login_with!(username, password)
    url = NSURL.URLWithString(INSTAPAPER_LOGIN)
    postData = "username=#{username}&password=#{password}".dataUsingEncoding(NSASCIIStringEncoding,
                                                                             allowLossyConversion:true)
    
    request = NSMustableURLRequest.requestWithURL(url)
    
    request.setHTTPMethod("POST")
    request.setValue("#{postData.length}", forHTTPHeaderField:"Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
    request.setHTTPBody(postData)
    
    
    self.connection = NSURLConnection.connectionWithRequest(request, delegate:self)
  end
  
  def connection(connection, didReceiveResponse:response)
    allCookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response.allHeaderFields forURL:NSURL.URLWithString("http://www.instapaper.com"))
    puts("Number of cookies received: #{allCookies.size}")
    
    # Store the cookies:
    # NSHTTPCookieStorage is a Singleton.
    NSHTTPCookieStorage.sharedHTTPCookieStorage.setCookies(all,
                                                    forURL:NSURL.URLWithString("http://www.instapaper.com"),
                                           mainDocumentURL:nil)
#    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://temp"] mainDocumentURL:nil];

    # Now we can print all of the cookies we have:
    all.each do |cookie|
      puts("Name: #{cookie.name} : Value: #{cookie.value}, Expires: #{cookie.expireData}")
    end
  end
  
  def logout!
    # pending
  end
  
  def has_login_credentials_already?
  
  end
  
end