# Story.rb
# Paperadio
#
# Created by Arun Thampi on 11/20/10.
# Copyright 2010 Deepcalm Apps. All rights reserved.

class Story
  attr_accessor :title, :url
  
  def initialize(opts = {})
    opts.each_pair { |k, v| self.send("#{k}=", v) if self.respond_to?(k) }
  end
  
end

