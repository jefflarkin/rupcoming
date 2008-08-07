require 'cgi'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
  # This class implements the Event.* methods of the Upcoming.org API
  class Event < Base
    # Wrapper function, will emulate the behavior of ActiveRecord.find
    def self.find(options = {})
      if options['event_id']
        self.find_by_event_id(options['event_id'])
      elsif options['venue_id']
        per_page = options['per_page'] || 5
        self.find_by_venue_id(options['venue_id'], per_page)
      end
    end
    # Implements the Event.getInfo method
    def self.getInfo(event_id)
      url_options = "&method=event.getInfo&event_id=#{event_id}"
      results = remote_fetch(url_options)
      Event.new(results['event'][0]) unless results.nil?
    end
    # Alias for the Event.getInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_event_id(event_id)
      getInfo(event_id)
    end

    # Implements Event.search.  Pass a Hash of options, as documented
    # by the Upcoming.org API.  This method does not check that the
    # options passed are valid options to Event.search.
    def self.search(options = {})
      url_options = "&method=event.search"
      options.each do |key,val|
        url_options << "&#{key}=#{CGI.escape(val.to_s)}" unless val.nil?
      end
      events = []
      result =  remote_fetch(url_options)
      if result.nil? || result['event'].nil?
        nil
      else
        result['event'].each do |event|
          events << Event.new(event)
        end
        events
      end
    end
    # Parital implementation of the Event.search method for finding
    # events for a venue.  Intended to emulate ActiveRecord find
    # behavior.
    def self.find_by_venue_id(venue_id, limit=5)
      search :venue_id => venue_id, :per_page => limit
    end
  end
end
