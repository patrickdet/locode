require_relative '../test_helper'
 
describe Locode::Location do
  describe ".new" do
    it "must return a valid Location for valid parameters" do
      location_attributes = {
        country_code:                 'US',
        city_code:                    'NYC',
        full_name:                    'New York',
        full_name_without_diacritics: 'New York',
        subdivision:                  'NY',
        function:                     '12345---',
        status:                       'AI',
        date:                         '0401',
        iata_code:                    '',
        coordinates:                  '4042N 07400W'
      }
      location = Locode::Location.new(location_attributes)

      assert location.valid?
    end

    it "returns an invalid Location object for invalid parameters" do
      location = Locode::Location.new
      refute location.valid?
    end
  end
end
