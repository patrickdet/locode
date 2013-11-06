require 'csv'
require 'yaml'
require_relative '../lib/locode'

class LocodeDataUpdate
  attr_accessor :locations

  def initialize
    @locations = []
  end

  def parse
    parse_all_locations
    parse_all_references_entries
    write_to_yaml_file
  end

  private

  def parse_all_locations
    # the first round creates all objects
    Dir.glob('./data/csv/*.csv') do |file|
      CSV.parse(File.open(file)) do |row|
        unless country_row?(row) || reference_entry?(row)
          location_attributes = {
            country_code:                 row[1],
            city_code:                    row[2],
            full_name:                    row[3],
            full_name_without_diacritics: row[4],
            subdivision:                  row[5],
            function_classifier:          row[6],
            status:                       row[7],
            date:                         row[8], 
            iata_code:                    row[9],
            coordinates:                  row[10]
          }
          self.locations << Locode::Location.new(location_attributes)
        end
      end
    end
  end

  def parse_all_references_entries
    # the second round adds the alternate names to the objects
    Dir.glob('./data/csv/*.csv') do |file|
      CSV.parse(File.open(file)) do |row|
        if reference_entry?(row)
          location = self.locations.select do |location|
            location.country_code == row[1] &&
              location.full_name == get_name_from_row(row)
          end.first

          if location
            location.alternative_full_names = get_alternative_name_from_row(row)
            location.alternative_full_names_without_diacritics = get_alternative_name_without_diacritics_from_row(row)
          end
        end
      end
    end
  end

  def write_to_yaml_file
    File.open("./data/yaml/dump.yml", "w") {|f| f.write(locations.to_yaml) }
  end

  def country_row?(row)
    !!row[1] && !!row[3] && [0, 2, (4..11).to_a].flatten.all? {|r| !row[r] }
  end

  def reference_entry?(row)
    !!row[0] && row[0].strip == "="
  end

  def get_alternative_name_from_row(row)
    row[3].split("=").first.strip
  end

  def get_alternative_name_without_diacritics_from_row(row)
    row[4].split("=").first.strip
  end

  # should only be used with alternative names
  def get_name_from_row(row)
    row[3].split("=").last.strip
  end
end
