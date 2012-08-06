require File.expand_path('../spec_helper', __FILE__)

describe DayOne::SimpleXML do
  describe "#to_xml" do
    it "should corretly parse simple tags" do
      string = DayOne::SimpleXML.new{ key 'foo' }.to_s
      string.should include '<key>foo</key>'
    end
    
    it "should correctly parse options" do
      string = DayOne::SimpleXML.new{ key 'foo', option:'bar'}.to_s
      string.should include '<key option="bar">'
    end
  end
end