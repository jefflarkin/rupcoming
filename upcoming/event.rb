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
    # Implements the Event.getEventInfo method
    def self.getEventInfo(event_id)
      url_options = "&method=event.getInfo&event_id=#{event_id}"
      results = remote_fetch(url_options)['event']
      Event.new(results[0]) unless results.nil?
    end
    # Alias for the Event.getEventInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_event_id(event_id)
      getEventInfo(event_id)
    end
    # Parital implementation of the Event.search method for finding
    # events for a venue.  Intended to emulate ActiveRecord find
    # behavior.
    # FIXME: per_page should probably be renamed limit, like AR
    def self.find_by_venue_id(venue_id, per_page=5)
      url_options = "&method=event.search&venue_id=#{venue_id}&per_page=#{per_page}"
      events = []
      result =  remote_fetch(url_options)
      if result['event'].nil?
        nil
      else
        result['event'].each do |event|
          pp event
          events << Event.new(event)
        end
        events
      end
    end
  end
end
