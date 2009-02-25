# -*- vim: sw=2 ts=2 expandtabs
require 'cgi'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
  # This class implements the Metro.* methods of the Upcoming.org API
  class Metro < Base
    # Wrapper function, will emulate the behavior of ActiveRecord.find
    def self.find(options = {})
      if options['metro_id']
        self.find_by_metro_id(options['metro_id'])
      end
    end
    # Implements the Metro.getInfo method
    def self.getInfo(metro_id)
      url_options = "&method=metro.getInfo&metro_id=#{metro_id}"
      results = remote_fetch(url_options)
      Metro.new(results['metro'][0]) unless results.nil?
    end
    # Alias for the Metro.getMetroInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_metro_id(metro_id)
      getInfo(metro_id)
    end

    # Implements Metro.search.  Pass a Hash of options, as documented
    # by the Upcoming.org API.  This method does not check that the
    # options passed are valid options to Metro.search.
    def self.search(options = {})
      url_options = "&method=metro.search"
      options.each do |key,val|
        url_options << "&#{key}=#{CGI.escape(val.to_s)}" unless val.nil?
      end
      metros = []
      result =  remote_fetch(url_options)
      if result.nil? || result['metro'].nil?
        nil
      else
        result['metro'].each do |metro|
          metros << Metro.new(metro)
        end
        metros
      end
    end
  end
end
