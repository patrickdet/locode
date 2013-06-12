require_relative '../test_helper'
 
describe Locode do
  it "must have a defined version" do
    Locode::VERSION.wont_be_nil
  end
end
