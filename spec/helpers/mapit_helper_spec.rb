require 'spec_helper'

describe "MapitHelper" do
  before(:each) do
    klass = Class.new { include MapItHelper }
    @helper = klass.new
  end
  
  
  describe ".add_map" do
    it "should raise an ArgumentError when missing the map div and points" do
      lambda {
        @helper.add_map
      }.should raise_error(ArgumentError)
    end
    
    it "should content_for when passed a map div and points" do
      @helper.should_receive(:content_for).with(:mapit)
      @helper.add_map("map_div", [{:latitude => 1.1, :longitude => 30.3}])
    end
  end
  
end
