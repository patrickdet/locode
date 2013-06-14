# encoding: utf-8
module Locode
  class Location
    # Public: Initializes a new Location
    #
    # location_attributes - A Hash of the following structure
    #                       {
    #                         country_code:                 String | Symbol
    #                         city_code:                    String | Symbol
    #                         full_name:                    String
    #                         full_name_without_diacritics: String
    #                         subdivision:                  String | Symbol
    #                         function_classifier:          String | Array
    #                         status:                       String | Symbol
    #                         date:                         String
    #                         iata_code:                    String | nil
    #                         coordinates:                  String | nil
    #                       }
    #
    # Examples
    #
    #   Locode::Location.new
    #   #=> <Locode::Location: invalid location>
    #
    #   location_attributes = {
    #     country_code:                 'US',
    #     city_code:                    'NYC',
    #     full_name:                    'New York',
    #     full_name_without_diacritics: 'New York',
    #     subdivision:                  'NY',
    #     function_classifier:                     '12345---',
    #     status:                       'AI',
    #     date:                         '0401',
    #     iata_code:                    '',
    #     coordinates:                  '4042N 07400W'
    #   }
    #
    #   Locode::Location.new(location_attributes)
    #   #=> <Locode::Location: 'US NYC'>
    #
    #
    def initialize(location_attributes)
      location_attributes.each do |k,v|
        begin
          send("#{k}=", v) if !v.nil?
        rescue NoMethodError
        end
      end
    end

    # Internal: Once we are done parsing the csv files we no longer want to allow
    #           changes to the alternative_full_names or
    #           alternative_full_names_without_diacritics.
    #
    # Returns nothing
    def parsing_completed
      private :alternative_full_names=,
              :alternative_full_names_without_diacritics=,
              :parsing_completed
    end

    # Public: UN/LOCODE
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.locode
    #   #=> 'US NYC'
    #
    # Returns a String that represents the UN/LOCODE
    def locode
      "#{country_code.to_s} #{city_code.to_s}".strip
    end

    # Public: ISO 3166 alpha-2 Country Code
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.country_code
    #   #=> 'US'
    #
    # Returns a String containing the country code or an empty string.
    def country_code
      @country_code.to_s
    end

    # Public: Three letter code for a place
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.city_code
    #   #=> 'NYC'
    #
    # Returns a String containing the city code or an empty string.
    def city_code
      @city_code.to_s
    end

    # Public: The name of a location
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.full_name
    #   #=> 'Göteborg'
    #
    # Returns a String containing the full name of the location or an
    #         empty string.
    def full_name
      @full_name
    end

    # Public: The alternative names of a location
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.alternative_full_names
    #   #=> ['Gothenburg']
    #
    # Returns an Array of Strings containing the alternative full names of the
    #   location or an empty array.
    def alternative_full_names
      @alternative_full_names ||= []
    end

    # Internal: adds the alternative full name of a location to the list of alternatives
    #           This might not be coherent with the normal semantics of a setter
    #           but I think it is ok since it is just a private method.
    #
    # Returns nothing
    def alternative_full_names=(alternative_full_name)
      if alternative_full_name && alternative_full_name.is_a?(String)
        @alternative_full_names ||= []
        @alternative_full_names << alternative_full_name.strip
      end
    end

    # Public: The name of the location, but all non-latin-base characters
    #         are converted.
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.full_name_without_diacritics
    #   #=> 'Goteborg'
    #
    # Returns a String which contains the the full name without
    #         diacritics or an empty string
    def full_name_without_diacritics
      @full_name_without_diacritics
    end

    # Public: The alternative names of the location, but all non-latin-base
    #         characters are converted.
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.alternative_full_names_without_diacritics
    #   #=> ['Gothenburg']
    #
    # Returns an Array of Strings containing the alternative full names without
    #         diacritics of the location or an empty array.
    def alternative_full_names_without_diacritics
      @alternative_full_names_without_diacritics ||= []
    end

    # Internal: adds the alternative full name without diacritics of the location
    #           to the list of alternatives.
    #           This might not be coherent with the normal semantics of a setter
    #           but I think it is ok since it is just a private method.
    #
    # Returns nothing
    def alternative_full_names_without_diacritics=(alternative_full_name_without_diacritics)
      if alternative_full_name_without_diacritics && alternative_full_name_without_diacritics.is_a?(String)
        @alternative_full_names_without_diacritics ||= []
        @alternative_full_names_without_diacritics << alternative_full_name_without_diacritics.strip
      end
    end

    # Public: The ISO 1 to 3 character alphabetic and/or numeric code for the
    #         administrative division (state, province, department, etc.)
    #         of the country, as included in ISO 3166-2/1998. Only the
    #         latter part of the complete ISO 3166-2 code element (after
    #         the hyphen) is shown.
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.subdivision
    #   #=> 'NY'
    #
    #   Locode.find_by_locode('SE GOT').first.subdivision
    #   #=> 'O'
    #
    # Returns a String representing the subdivision or an empty string
    def subdivision
      @subdivision
    end

    # Public: contains a 1-digit function classifier code for the location
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.function_classifier
    #   #=> [1, 2, 3, 4, 5]
    #
    # Returns an Array containing Integer or :B with the following
    #   meanings:
    #   1 = seaport, any port with the possibility of transport via water
    #   2 = rail terminal
    #   3 = road terminal
    #   4 = airport
    #   5 = postal exchange office
    #   6 = Inland Clearance Depot – ICD or "Dry Port"
    #   7 = reserved for fixed transport functions (e.g. oil platform)
    #   :B = border crossing 
    def function_classifier
      @function_classifier
    end

    # Public: Indicates the status of the entry by a 2-character code
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.status
    #   #=> :AI
    #
    # Returns a Symbol with the following meaning or nil
    #   :AA = Approved by competent national government agency
    #   :AC = Approved by Customs Authority
    #   :AF = Approved by national facilitation body
    #   :AI = Code adopted by international organisation (IATA or ECLAC)
    #   :AM = Approved by the UN/LOCODE Maintenance Agency
    #   :AS = Approved by national standardisation body
    #   :AQ = Entry approved, functions not verified
    #   :RL = Recognised location - Existence and representation of location name
    #        confirmed by check against nominated gazetteer or other
    #        reference work
    #   :RN = Request from credible national sources for locations in their own country
    #   :RQ = Request under consideration
    #   :RR = Request rejected 
    #   :QQ = Original entry not verified since date indicated 
    #   :UR = Entry included on user's request; not officially approved 
    #   :XX = Entry that will be removed from the next issue of UN/LOCODE
    #
    def status
      @status
    end

    # Public: The date the location was added or updated
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.date
    #   #=> '0401'
    #
    # Returns a String containing the date the location was added to the
    #         list of LOCODEs. The meaning of the date values is the following:
    #         '0207' equals July 2002, '9501' equals January 1995
    def date
      @date
    end

    # Public: The IATA code for the location if different from the second
    #         part of the UN/LOCODE. Else the second part of the UN/LOCODE.
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.iata_code
    #   #=> 'XWL'
    #
    #   Locode.find_by_locode('US NYC').first.iata_code
    #   #=> 'NYC'
    #
    # Returns a String which is the IATA code if it is different from
    #         the city code of the LOCODE. Else it returns the city
    #         code.
    #
    def iata_code
      @iata_code
    end

    # Public: The coordinates of a location.
    #
    # Examples
    #
    #   Locode.find_by_locode('SE GOT').first.coordinates
    #   #=> nil
    #
    #   Locode.find_by_locode('SE GO2').first.coordinates
    #   #=> '5742N 01156E'
    #
    # Returns nil if no coordinates are associated with the Location
    #         otherwise it returns a String with the coordinates which
    #         represents these with two numbers and letters for the cardinal
    #         directions. The first followed by either N or S, the second by
    #         either E or W.
    def coordinates
      @coordinates
    end

    # Public: The String representation of the Location
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.to_s
    #   #=> <Locode::Location: 'US NYC'>
    #
    # Returns a String that represents the Location
    def to_s
      "<Locode::Location: '#{locode}'>"
    end

    # Public: To check whether the Locations attributes are all
    #         initialized correctly.
    #
    # Examples
    #
    #   Locode.find_by_locode('US NYC').first.valid?
    #   #=> true
    #
    #   Locode::Location.new.valid?
    #   #=> false
    #
    # Returns true or false
    def valid?
      country_code && country_code.size == 2 && city_code && city_code.size == 3
    end

    private

    # Internal: sets the ISO 3166 alpha-2 Country Code
    #
    # Returns nothing
    def country_code=(country_code)
      if country_code
        if country_code.is_a?(String)
          @country_code = country_code.strip.upcase.to_sym
        elsif country_code.is_a?(Symbol)
          @country_code = country_code.upcase
        end
      end
    end

    # Internal: sets the three letter code for a place
    #
    # Returns nothing
    def city_code=(city_code)
      if city_code
        if city_code.is_a?(String)
          @city_code = city_code.strip.upcase.to_sym
        elsif city_code.is_a?(Symbol)
          @city_code = city_code.upcase
        end
      end
    end

    # Internal: sets the name of a location
    #
    # Returns nothing
    def full_name=(full_name)
      if full_name && full_name.is_a?(String)
        @full_name = full_name.strip
      end
    end

    # Internal: sets the full name without diacritics of the location
    #
    # Returns nothing
    def full_name_without_diacritics=(full_name_without_diacritics)
      if full_name_without_diacritics && full_name_without_diacritics.is_a?(String)
        @full_name_without_diacritics = full_name_without_diacritics.strip
      end
    end

    # Internal: sets the ISO 1 to 3 character alphabetic and/or numeric code
    #
    # Returns nothing
    def subdivision=(subdivision)
      if subdivision && subdivision.is_a?(String)
        @subdivision = subdivision.strip
      end
    end

    # Internal: sets the 1-digit function classifier code for the location
    #
    # Returns nothing
    def function_classifier=(function_classifier)
      if function_classifier
        if function_classifier.is_a?(String)
          @function_classifier = function_classifier.strip.chars.select do |char|
            char.to_i.between?(1, 7) || char.upcase.to_s == "B"
          end.map do |char|
            if char.to_i.between?(1, 7)
              char.to_i
            else
              char.upcase.to_sym
            end
          end
        elsif function_classifier.is_a?(Array)
          @function_classifier = function_classifier.flatten
        end
      end
    end

    # Internal: sets the status indicator of the entry
    #
    # Returns nothing
    def status=(status)
      if status && (status.is_a?(String) || status.is_a?(Symbol))
        @status = status.upcase.to_sym
      end
    end

    # Internal: sets the date the location was added or updated
    #
    # Returns nothing
    def date=(date)
      if date && date.is_a?(String)
        @date = date.strip
      end
    end

    # Internal: sets the IATA code for the location
    #
    # Returns nothing
    def iata_code=(iata_code)
      if iata_code && iata_code.is_a?(String)
        @iata_code = iata_code.strip
      end
    end

    # Internal: sets the coordinates of a location.
    #
    # Returns nothing
    def coordinates=(coordinates)
      if coordinates && coordinates.is_a?(String)
        @coordinates = coordinates.strip
      end
    end

    # Internal: Used to link name of a status and the status number
    def self.functions_name_identifier
      {
        seaport: 1,
        rail_terminal: 2,
        road_terminal: 3,
        airport: 4,
        postal_exchange_office: 5,
        inland_clearance_depot: 6,
        fixed_transport_functions: 7,
        border_crossing: :B
      }
    end

    # Dynamically defines the following predicates:
    #
    # seaport?
    # rail_terminal?
    # road_terminal?
    # airport?
    # postal_exchange_office?
    # inland_clearance_depot?
    # fixed_transport_functions?
    # border_crossing?
    #
    # Each returns: true | false
    #
    functions_name_identifier.each do |key, value|
      define_method "#{key}?" do
        function_classifier.include?(value)
      end
    end
  end
end
