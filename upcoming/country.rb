# -*- vim: sw=2 ts=2 expandtabs
require 'cgi'
# Author:: Jeff larkin (mailto: jeff.larkin@gmail.com)
# Copyright:: Copyright (c) 2008 Jeff Larkin
# License:: MIT License
module Upcoming
  # This class implements the Country.* methods of the Upcoming.org API
  class Country < Base
    # Wrapper function, will emulate the behavior of ActiveRecord.find
    def self.find(options = {})
      if options['country_id']
        self.find_by_country_id(options['country_id'])
      end
    end
    # Implements the Country.getInfo method
    def self.getInfo(country_id)
      url_options = "&method=country.getInfo&country_id=#{country_id}"
      results = remote_fetch(url_options)
      Country.new(results['country'][0]) unless results.nil?
    end
    # Alias for the Country.getInfo method, intended to emulate
    # ActiveRecord behavior
    def self.find_by_country_id(country_id)
      getInfo(country_id)
    end
  end
end
