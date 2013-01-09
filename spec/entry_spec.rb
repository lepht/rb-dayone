require './spec/spec_helper'
require 'fileutils'

describe DayOne::Entry do
  before :each do
    setup_working
  end
  
  after :each do
    clean_working
  end
  
  describe "#to_xml" do
    
    let(:sample_entry){ DayOne::Entry.new('foo', starred:true) }
    
    it "should give a default entry" do
      e = subject.to_xml
      e.should match %r|<key>Entry Text</key>\s*<string></string>|
      e.should match %r|<key>Starred</key>\s*<false/>|
    end
    
    it "should set from initialize" do
      sample_entry.starred.should be_true
      sample_entry.entry_text.should == 'foo'
      sample_entry.should_not be_saved
    end
    
    it "should act properly when starred" do
      sample_entry.to_xml.should match %r|<key>Starred</key>\s*<true/>|
    end

    it "should populate with tags" do
      s = sample_entry
      s.tag 'foo'
      s.to_xml.should match %r|<key>Tags</key>\s*<array>\s*<string>foo</string>|
    end
  end
  
  describe "#create!" do
    it "should correctly create a .doentry file" do
      
      
      e = subject
      e.entry_text = "Hello, world!"
      e.create!
      
      file_location = Dir[spec_data('working', 'entries', '*.doentry')][0]
      file_location.should_not be_nil
      
      contents = File.read(file_location)
      contents.should == e.to_xml
    end
  end
  
  describe "#xml_valid?" do
    it "should handle weird XML characters" do
      e = subject
      e.entry_text = "Hello <&> Goodbye"
      e.should be_xml_valid
    end
  end
end