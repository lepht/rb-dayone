require File.expand_path('../spec_helper', __FILE__)

describe DayOne::Entry do
  describe "#to_xml" do
    it "should give a default entry" do
      entry = DayOne::Entry.new.to_xml
      entry.should match %r|<key>Entry Text</key>\n\s+<string></string>|
      entry.should match %r|<key>Starred</key>\n\s+<false />|
    end
    
    it "should set from initialize" do
      entry = DayOne::Entry.new starred:true, entry_text:'foo'
      entry.starred.should be_true
      entry.entry_text.should == 'foo'
    end
    
    it "should act properly when starred" do
      entry = DayOne::Entry.new(starred:true).to_xml
      entry.should match %r|<key>Starred</key>\n\s+<true />|
    end
  end
end