# encoding: utf-8
require_relative "locode/version"
require_relative "locode/location"

module Locode
  ALL_LOCATIONS = nil
  private_constant :ALL_LOCATIONS

  def self.seaports
    []
  end

  def self.rails_terminals
  end

  def self.road_terminals
  end

  def self.airports
  end

  def self.postal_exchange_offices
  end

  def self.inland_clearance_depots
  end

  # the spec says these are currently just oil platforms
  def self.fixed_transport_functions
  end

  def self.border_crossing_functions
  end

  # Public: Find Locations that partially match the Search String.
  #         This means you can search by just the country code or a
  #         whole LOCODE.
  #
  # search_string - The string that will be used in the LOCODE search.
  #
  # Examples
  #
  #   Locode.find_by_locode('US')
  #   #=> [<Locode::Location: 'US NYC'>,
  #        <Locode::Location: 'US LAX'>, ... ]
  #
  #   Locode.find_by_locode('DE HAM')
  #   #=> [<Locode::Location: 'DE HAM'>]
  #
  #   Locode.find_by_locode('foobar')
  #   #=> []
  #
  # Returns an Array of Location
  def self.find_by_locode(search_string)
  end


  # Public: Find Locations whose full name or full name without diacritics
  #         matches the search string
  #
  # search_string - The string that will be used in the LOCODE search.
  #
  # Examples
  #
  #   Locode.find_by_full_name('Göteborg')
  #   #=> [<Locode::Location: 'SE GOT'>]
  #
  #   Locode.find_by_full_name('Gothenburg')
  #   #=> [<Locode::Location: 'SE GOT'>]
  #
  # Returns an Array of Location because the name might not be unique
  def self.find_by_full_name(search_string)
  end

  def self.load_data
    nil
  end
end
