require './spec/spec_helper'

describe DayOne::Location do
  describe "#initialize" do
    it "should set via symbol" do
      l = DayOne::Location.new(administrative_area: 'foo')
      l.administrative_area.should eq('foo')
    end

    it "should set via string" do
      l = DayOne::Location.new('Administrative Area' => 'foo')
      l.administrative_area.should eq('foo')
    end
  end

  describe "#left_blank?" do
    it "should return true if all values are nil, '' or 0" do
      l = DayOne::Location.new
      l.left_blank?.should be_true
      l.country = ''
      l.latitude = 0.0
      l.longitude = 0
      l.left_blank?.should be_true
      l.place_name = '!'
      l.left_blank?.should be_false
    end
  end

  describe "#to_xml" do
    it "should export correctly to xml" do
      b = double('Builder')
      b.should_receive(:key).exactly(7).times
      b.should_receive(:string).exactly(4).times
      b.should_receive(:real).exactly(2).times
      b.should_receive(:dict){ |&blck| blck.call }
      DayOne::Location.new(country:'New Zealand').to_xml(b).should be_true
    end
  end
end