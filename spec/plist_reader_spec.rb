require './spec/spec_helper'

describe DayOne::PlistReader do
  describe "#initialize" do
    it "should default to the normal preference file" do
      File.should exist(subject.path)
    end
  end
  
  describe "#body" do
    it "should correctly parse binary plists" do
      reader = DayOne::PlistReader.new(File.join(File.dirname(__FILE__),'data', 'sample.plist'))

      reader.key('foo').should == 'bar'
      reader.key('bing').should be_nil
    end
  end
end