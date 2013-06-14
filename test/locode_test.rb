require_relative 'test_helper'

describe Locode do
  describe ".find_by_locode" do
    it "should return the correct location" do
      locode = "DE HAM"
      location = Locode.find_by_locode(locode).first

      location.locode.must_equal locode
    end
  end

  describe ".find_by_name" do
    it "should find the location for a given name" do
      name = "Hamburg"
      location = Locode.find_by_name(name).first

      location.full_name.must_equal name
    end
  end
end
