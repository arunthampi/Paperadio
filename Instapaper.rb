# Instapaper.rb
# Paperadio
#
# Created by Arun Thampi on 11/20/10.
# Copyright 2010 Deepcalm Apps. All rights reserved.

require 'cgi'

class Instapaper
  INSTAPAPER_URL = "http://www.instapaper.com/u"
  INSTAPAPER_LOGIN = "http://www.instapaper.com/user/login"
  
  MAPPINGS = {
    'Aacute' => 193,
    'aacute' => 225,
    'Acirc' => 194,
    'acirc' => 226,
    'acute' => 180,
    'AElig' => 198,
    'aelig' => 230,
    'Agrave' => 192,
    'agrave' => 224,
    'alefsym' => 8501,
    'Alpha' => 913,
    'alpha' => 945,
    'amp' => 38,
    'and' => 8743,
    'ang' => 8736,
    'apos' => 39,
    'Aring' => 197,
    'aring' => 229,
    'asymp' => 8776,
    'Atilde' => 195,
    'atilde' => 227,
    'Auml' => 196,
    'auml' => 228,
    'bdquo' => 8222,
    'Beta' => 914,
    'beta' => 946,
    'brvbar' => 166,
    'bull' => 8226,
    'cap' => 8745,
    'Ccedil' => 199,
    'ccedil' => 231,
    'cedil' => 184,
    'cent' => 162,
    'Chi' => 935,
    'chi' => 967,
    'circ' => 710,
    'clubs' => 9827,
    'cong' => 8773,
    'copy' => 169,
    'crarr' => 8629,
    'cup' => 8746,
    'curren' => 164,
    'Dagger' => 8225,
    'dagger' => 8224,
    'dArr' => 8659,
    'darr' => 8595,
    'deg' => 176,
    'Delta' => 916,
    'delta' => 948,
    'diams' => 9830,
    'divide' => 247,
    'Eacute' => 201,
    'eacute' => 233,
    'Ecirc' => 202,
    'ecirc' => 234,
    'Egrave' => 200,
    'egrave' => 232,
    'empty' => 8709,
    'emsp' => 8195,
    'ensp' => 8194,
    'Epsilon' => 917,
    'epsilon' => 949,
    'equiv' => 8801,
    'Eta' => 919,
    'eta' => 951,
    'ETH' => 208,
    'eth' => 240,
    'Euml' => 203,
    'euml' => 235,
    'euro' => 8364,
    'exist' => 8707,
    'fnof' => 402,
    'forall' => 8704,
    'frac12' => 189,
    'frac14' => 188,
    'frac34' => 190,
    'frasl' => 8260,
    'Gamma' => 915,
    'gamma' => 947,
    'ge' => 8805,
    'gt' => 62,
    'hArr' => 8660,
    'harr' => 8596,
    'hearts' => 9829,
    'hellip' => 8230,
    'Iacute' => 205,
    'iacute' => 237,
    'Icirc' => 206,
    'icirc' => 238,
    'iexcl' => 161,
    'Igrave' => 204,
    'igrave' => 236,
    'image' => 8465,
    'infin' => 8734,
    'int' => 8747,
    'Iota' => 921,
    'iota' => 953,
    'iquest' => 191,
    'isin' => 8712,
    'Iuml' => 207,
    'iuml' => 239,
    'Kappa' => 922,
    'kappa' => 954,
    'Lambda' => 923,
    'lambda' => 955,
    'lang' => 9001,
    'laquo' => 171,
    'lArr' => 8656,
    'larr' => 8592,
    'lceil' => 8968,
    'ldquo' => 8220,
    'le' => 8804,
    'lfloor' => 8970,
    'lowast' => 8727,
    'loz' => 9674,
    'lrm' => 8206,
    'lsaquo' => 8249,
    'lsquo' => 8216,
    'lt' => 60,
    'macr' => 175,
    'mdash' => 8212,
    'micro' => 181,
    'middot' => 183,
    'minus' => 8722,
    'Mu' => 924,
    'mu' => 956,
    'nabla' => 8711,
    'nbsp' => 160,
    'ndash' => 8211,
    'ne' => 8800,
    'ni' => 8715,
    'not' => 172,
    'notin' => 8713,
    'nsub' => 8836,
    'Ntilde' => 209,
    'ntilde' => 241,
    'Nu' => 925,
    'nu' => 957,
    'Oacute' => 211,
    'oacute' => 243,
    'Ocirc' => 212,
    'ocirc' => 244,
    'OElig' => 338,
    'oelig' => 339,
    'Ograve' => 210,
    'ograve' => 242,
    'oline' => 8254,
    'Omega' => 937,
    'omega' => 969,
    'Omicron' => 927,
    'omicron' => 959,
    'oplus' => 8853,
    'or' => 8744,
    'ordf' => 170,
    'ordm' => 186,
    'Oslash' => 216,
    'oslash' => 248,
    'Otilde' => 213,
    'otilde' => 245,
    'otimes' => 8855,
    'Ouml' => 214,
    'ouml' => 246,
    'para' => 182,
    'part' => 8706,
    'permil' => 8240,
    'perp' => 8869,
    'Phi' => 934,
    'phi' => 966,
    'Pi' => 928,
    'pi' => 960,
    'piv' => 982,
    'plusmn' => 177,
    'pound' => 163,
    'Prime' => 8243,
    'prime' => 8242,
    'prod' => 8719,
    'prop' => 8733,
    'Psi' => 936,
    'psi' => 968,
    'quot' => 34,
    'radic' => 8730,
    'rang' => 9002,
    'raquo' => 187,
    'rArr' => 8658,
    'rarr' => 8594,
    'rceil' => 8969,
    'rdquo' => 8221,
    'real' => 8476,
    'reg' => 174,
    'rfloor' => 8971,
    'Rho' => 929,
    'rho' => 961,
    'rlm' => 8207,
    'rsaquo' => 8250,
    'rsquo' => 8217,
    'sbquo' => 8218,
    'Scaron' => 352,
    'scaron' => 353,
    'sdot' => 8901,
    'sect' => 167,
    'shy' => 173,
    'Sigma' => 931,
    'sigma' => 963,
    'sigmaf' => 962,
    'sim' => 8764,
    'spades' => 9824,
    'sub' => 8834,
    'sube' => 8838,
    'sum' => 8721,
    'sup' => 8835,
    'sup1' => 185,
    'sup2' => 178,
    'sup3' => 179,
    'supe' => 8839,
    'szlig' => 223,
    'Tau' => 932,
    'tau' => 964,
    'there4' => 8756,
    'Theta' => 920,
    'theta' => 952,
    'thetasym' => 977,
    'thinsp' => 8201,
    'THORN' => 222,
    'thorn' => 254,
    'tilde' => 732,
    'times' => 215,
    'trade' => 8482,
    'Uacute' => 218,
    'uacute' => 250,
    'uArr' => 8657,
    'uarr' => 8593,
    'Ucirc' => 219,
    'ucirc' => 251,
    'Ugrave' => 217,
    'ugrave' => 249,
    'uml' => 168,
    'upsih' => 978,
    'Upsilon' => 933,
    'upsilon' => 965,
    'Uuml' => 220,
    'uuml' => 252,
    'weierp' => 8472,
    'Xi' => 926,
    'xi' => 958,
    'Yacute' => 221,
    'yacute' => 253,
    'yen' => 165,
    'Yuml' => 376,
    'yuml' => 255,
    'Zeta' => 918,
    'zeta' => 950,
    'zwj' => 8205,
    'zwnj' => 8204
  }
  
  attr_accessor :stories
  attr_accessor :parent
  attr_accessor :current_story_text
  attr_accessor :current_speaker
  attr_accessor :current_story_index
  attr_accessor :is_speaking
  attr_accessor :coder
  
  def initialize
    super
    self.stories = []
    self.current_story_text = nil
    self.current_speaker = nil
    self.current_story_index = 0
  end
  
  def login_with!(username, password)
    request = ASIFormDataRequest.requestWithURL(NSURL.URLWithString(INSTAPAPER_LOGIN))
    request.setPostValue(username, forKey:"username")
    request.setPostValue(password, forKey:"password")

    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
  end
  
  def fetch_first_page
    request = ASIHTTPRequest.requestWithURL(NSURL.URLWithString(INSTAPAPER_URL))

    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
  end

  def requestFinished(request)
    if (request.url.absoluteString == INSTAPAPER_LOGIN &&
        request.responseStatusCode == 200)
      NSLog("Successfully logged in")
      self.fetch_first_page
    elsif (request.url.absoluteString == INSTAPAPER_URL &&
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
  
  def get_individual_story_from(index)
    self.current_story_index = index.to_i
    url = self.stories[self.current_story_index].url

    request = ASIHTTPRequest.requestWithURL(NSURL.URLWithString("http://www.instapaper.com/text?u=#{CGI.escape(url)}"))
    request.delegate = self
    request.startAsynchronous
    
    self.parent.activity_indicator.startAnimation(self)
  end
  
  def toggle_play_pause
    if self.current_speaker
      if self.current_speaker.isSpeaking
        # enum NSSpeechWordBoundary
        self.current_speaker.pauseSpeakingAtBoundary(0)
      else
        self.current_speaker.continueSpeaking
      end
      
      self.is_speaking = !self.is_speaking
      self.parent.togglePlayPauseButtonImage
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
  
  def decode_html_entities(source)
    source.to_s.gsub(named_entity_regexp) {
      (codepoint = MAPPINGS[$1]) ? [codepoint].pack('U') : $&
    }.gsub(/&#(?:([0-9]{1,7})|x([0-9a-f]{1,6}));/i) {
      $1 ? [$1.to_i].pack('U') : [$2.to_i(16)].pack('U')
    }
  end
  
protected
  def named_entity_regexp
    key_lengths = MAPPINGS.keys.map{ |k| k.length }
    entity_name_pattern =
      if @flavor == 'expanded'
        '(?:b\.)?[a-z][a-z0-9]'
      else
        '[a-z][a-z0-9]'
      end
    /&(#{ entity_name_pattern }{#{ key_lengths.min - 1 },#{ key_lengths.max - 1 }});/i
  end


  def collect_stories_from(page)
    page.scan(/<a.*?a>/im).select { |y| y =~ /tableViewCellTitleLink/ }.each do |raw_story|
      match = raw_story.match(/<a.*?href="(.*?)".*?>(.*?)<\/a>/im)
      self.stories << (story = Story.new(:url => match[1], :title => decode_html_entities(match[2])))
    end
  end
  
  def read_story(story)
    if self.current_speaker
      self.current_speaker.stopSpeaking if self.current_speaker.isSpeaking
      self.current_speaker = nil
    end
    
    story = decode_html_entities(story)
    
    NSLog("Story : #{story}")
    
    self.current_speaker = NSSpeechSynthesizer.alloc.initWithVoice("com.apple.speech.synthesis.voice.Victoria")
    self.current_speaker.rate = 210.0
    self.current_speaker.startSpeakingString(story)

    self.is_speaking = true
    
    self.parent.togglePlayPauseButtonImage
    self.parent.updateNowPlayingWith(self.stories[self.current_story_index].title)
  end
end