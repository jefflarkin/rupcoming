# -*- vim: sw=2 ts=2 expandtabs
require 'cgi'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
  # This class implements the State.* methods of the Upcoming.org API
  class State < Base
    # Wrapper function, will emulate the behavior of ActiveRecord.find
    def self.find(options = {})
      if options['state_id']
        self.find_by_state_id(options['state_id'])
      end
    end
    # Implements the State.getInfo method
    def self.getInfo(state_id)
      url_options = "&method=state.getInfo&state_id=#{state_id}"
      results = remote_fetch(url_options)
      State.new(results['state'][0]) unless results.nil?
    end
    # Alias for the State.getInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_state_id(state_id)
      getInfo(state_id)
    end
  end
end
