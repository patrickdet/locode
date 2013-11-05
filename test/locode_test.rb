require_relative 'test_helper'

describe Locode do
  describe '.find_by_locode' do
    it 'should return the correct location' do
      locode = 'DE HAM'
      location = Locode.find_by_locode(locode).first

      location.locode.must_equal locode
    end
  end

  describe '.find_by_name' do
    it 'should find the location for a given name' do
      name = 'Hamburg'
      location = Locode.find_by_name(name).first

      location.full_name.must_equal name
    end
  end

  describe 'find locations by country for function' do

    describe 'invalid calls' do
      it 'returns an empty array when country code is empty' do
        Locode.find_by_country_and_function(nil, 1).must_be_empty
      end

      it 'returns an empty array when country code is not a string' do
        Locode.find_by_country_and_function(12, 1).must_be_empty
      end

      it 'returns an empty array when country code is not 2 chars long' do
        Locode.find_by_country_and_function('ABC', 1).must_be_empty
        Locode.find_by_country_and_function('A', 1).must_be_empty
      end

      it 'returns an empty array when country code is not in upper case' do
        Locode.find_by_country_and_function('aa', 1).must_be_empty
        Locode.find_by_country_and_function('a', 1).must_be_empty
      end

      it 'returns an empty array when function is not a possible function' do
        Locode.find_by_country_and_function('AB', 9).must_be_empty
        Locode.find_by_country_and_function('AB', 0).must_be_empty
        Locode.find_by_country_and_function('AB', nil).must_be_empty
        Locode.find_by_country_and_function('AB', ':C').must_be_empty
        Locode.find_by_country_and_function('AB', ':b').must_be_empty
      end
    end

    describe 'valid calls' do
      let(:seaport) { Locode::Location.new country_code: 'BE', full_name: 'Antwerp', function_classifier: [1] }
      let(:airport) { Locode::Location.new country_code: 'BE', full_name: 'Brussels', function_classifier: [4] }
      let(:railstation) { Locode::Location.new country_code: 'NL', full_name: 'Venlo', function_classifier: [2] }

      before do
        # exploit Ruby's constant lookup mechanism
        locations = []
        locations << seaport << airport << railstation
        Locode::ALL_LOCATIONS = locations
      end

      it 'excepts :B as a valid function' do
        Locode.find_by_country_and_function('AB', ':B').must_be_empty
      end

      it 'finds all locations for Belgium as seaport' do
        locations = Locode.find_by_country_and_function('BE', 1)
        locations.count.must_equal 1
        locations.must_include seaport
        locations.wont_include airport
        locations.wont_include railstation
      end

      it 'finds all railstations in the Netherlands' do
        locations = Locode.find_by_country_and_function('NL', 2)
        locations.count.must_equal 1
        locations.must_include railstation
        locations.wont_include airport
        locations.wont_include seaport
      end
    end
  end
end