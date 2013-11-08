# encoding: utf-8
require 'yaml'
require 'multi_json'

require_relative 'locode/version'
require_relative 'locode/location'

module Locode

  def self.load_data
    YAML.load(File.read(File.expand_path('../../data/yaml/dump.yml', __FILE__)))
  end
  private_class_method :load_data

  ALL_LOCATIONS = load_data
  private_constant :ALL_LOCATIONS

  def self.seaports(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.seaport? }.take(limit)
  end

  def self.rail_terminals(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.rail_terminal? }.take(limit)
  end

  def self.road_terminals(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.road_terminal? }.take(limit)
  end

  def self.airport(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.airport? }.take(limit)
  end

  def self.postal_exchange_offices(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.postal_exchange_office? }.take(limit)
  end

  def self.inland_clearance_depots(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.inland_clearance_depot? }.take(limit)
  end

  # the spec says these are currently just oil platforms
  def self.fixed_transport_functions(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.fixed_transport_functions? }.take(limit)
  end

  def self.border_crossing_functions(limit = ALL_LOCATIONS.size)
    ALL_LOCATIONS.select { |location| location.border_crossing? }.take(limit)
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
    return [] unless search_string && search_string.is_a?(String)
    ALL_LOCATIONS.select { |location| location.locode.start_with?(search_string.strip.upcase) }
  end

  # Public: Find Locations whose full name or full name without diacritics
  #         matches the search string
  #
  # search_string - The string that will be used in the LOCODE search.
  #
  # Examples
  #
  #   Locode.find_by_name('Göteborg')
  #   #=> [<Locode::Location: 'SE GOT'>]
  #
  #   Locode.find_by_name('Gothenburg')
  #   #=> [<Locode::Location: 'SE GOT'>]
  #
  # Returns an Array of Location because the name might not be unique
  def self.find_by_name(search_string)
    return [] unless search_string && search_string.is_a?(String)
    ALL_LOCATIONS.select do |location|
      names = []
      names << location.full_name if location.full_name
      names << location.full_name_without_diacritics if location.full_name_without_diacritics
      names += location.alternative_full_names
      names += location.alternative_full_names_without_diacritics
      names.map { |name| name.downcase }.any? { |name| name.start_with?(search_string.strip.downcase) }
    end
  end

  # Public: Find locations for a specific country with a specific function
  #
  # country_code - ISO 3166 alpha-2 Country Code String to filter locations by country
  # function - Integer or :B that specifies the function of the location
  # limit - Integer to specify how many locations you want
  #
  # Examples
  #
  #   Locode.find_by_country_and_function('BE', 1)
  #   #=> [<Locode::Location: 'BE ANR'>, ..]
  #
  # Returns an Array of Locations that satisfy the above conditions
  def self.find_by_country_and_function(country_code, function, limit = ALL_LOCATIONS.size)
    return [] unless country_code.to_s =~ /^[A-Z]{2}$/
    return [] unless function.to_s =~ /^[1-7]{1}|:B{1}$/

    ALL_LOCATIONS.select { |location| location.country_code == country_code && location.function_classifier.include?(function) }.take(limit)
  end
end
