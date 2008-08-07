require 'cgi'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
  # This class implements the Venue.* methods of the Upcoming.org API
  class Venue < Base
    # Wrapper function, will emulate the behavior of ActiveRecord.find
    def self.find(options = {})
      if options['venue_id']
        self.find_by_venue_id(options['venue_id'])
      end
    end
    # Implements the Venue.getInfo method
    def self.getInfo(venue_id)
      url_options = "&method=venue.getInfo&venue_id=#{venue_id}"
      results = remote_fetch(url_options)
      Venue.new(results['venue'][0]) unless results.nil?
    end
    # Alias for the Venue.getInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_venue_id(venue_id)
      getInfo(venue_id)
    end

    # Implements Venue.search.  Pass a Hash of options, as documented
    # by the Upcoming.org API.  This method does not check that the
    # options passed are valid options to Venue.search.
    def self.search(options = {})
      url_options = "&method=venue.search"
      options.each do |key,val|
        url_options << "&#{key}=#{CGI.escape(val.to_s)}" unless val.nil?
      end
      venues = []
      result =  remote_fetch(url_options)
      if result.nil? || result['venue'].nil?
        nil
      else
        result['venue'].each do |venue|
          venues << Venue.new(venue)
        end
        venues
      end
    end
  end
end
