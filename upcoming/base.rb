require 'rubygems'
require 'xmlsimple'
require 'net/http'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
# This is the Base class from which each Upcoming Method Class
# will be based.
  class Base
    @@apikey = ""

    # Set the Upcoming.org API key
    def self.apikey=(apikey)
      @@apikey=apikey
    end

    # Fetch the Upcoming.org API key
    def self.apikey
      @@apikey
    end

    # Initialize the class from a Hash object.  Each key/value
    # pair will be made into instance variable with appropriate
    # get/set methods.
    def initialize(hash = {})
      str = ""
      
      # Turn every key/value pair in the input hash into variables.
      hash.each do |key,val|
        if val.nil?
          newval = ""
        else
          newval = val.gsub(/['"\\\x0]/,'\\\\\0') 
        end

        # Need to add slashes to handles single quotes in the data, but
        # we'll immediatly strip them once the string has been safely eval'ed
        eval "@#{key} = '#{newval}';@#{key}.gsub!(/\\\\(.)/,'\\1')"

        # All attr_accessor calls must be class_eval'ed, so we'll put them
        # together to do all at once.
        str << "attr_accessor '#{key}';"
      end
      
      # Put in the getter/setter methods
      Base.class_eval str
    end

    protected
    # 
    # This routine is used to fetch the data from a remote URL
    # url_options gets appended to the base URL
    def self.remote_fetch(url_options)
      url = "http://upcoming.yahooapis.com/services/rest/?api_key=#{@@apikey}"
      begin 
        data = Net::HTTP.get_response(URI.parse("#{url}#{url_options}")).body
        hash = XmlSimple.xml_in(data)
        if hash['error']
          nil
        else
          hash
        end
      rescue
        nil
      end
    end
  end

  # The two methods below may be removed or placed in an extension of
  # the String class.  The are left here for reference only.
   
  # Because we're dealing with potentially unsafe user input we will
  # need to escape all quotes.
  def addslashes(str)
    str.gsub(/['"\\\x0]/,'\\\\\0')
  end

  # Unescapes quotes from addslashes
  def stripslashes(str)
    str.gsub(/\\(.)/,'\1')
  end
end
