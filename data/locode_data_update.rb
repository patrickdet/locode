require 'csv'
require 'yaml'
require_relative '../lib/locode'

class LocodeDataUpdate
  attr_accessor :locations

  def initialize
    @locations = []
  end

  def parse
    # the first round creates all objects
    Dir.glob('./data/csv/*.csv') do |file|
      CSV.parse(File.open(file)) do |row|
        #unless row[0].strip == "="
          location_attributes = {
            country_code:                 row[1],
            city_code:                    row[2],
            full_name:                    row[3],
            full_name_without_diacritics: row[4],
            subdivision:                  row[5],
            function:                     row[6],
            status:                       row[7],
            date:                         row[8], 
            iata_code:                    row[9],
            coordinates:                  row[10]
          }
          self.locations << Locode::Location.new(location_attributes)
        #end
      end 
    end

    # the second round adds the alternate names to the objects
  end
end
