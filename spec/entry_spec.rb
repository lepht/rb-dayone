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
      s.tag 'bar'
      s.to_xml.should match %r|<key>Tags</key>\s*<array>\s*<string>foo</string>\s*<string>bar</string>|
    end

    it "should put locations into the xml" do
      s = sample_entry
      s.location.country = 'New Zealand'
      doc = Nokogiri::XML(s.to_xml)
      dict = doc.xpath('//plist/dict/dict')
      dict.size.should eq(1)
      dict.first.xpath('//string').select{ |s| s.content == 'New Zealand' }.size.should eq(1)
    end

    it "should automatically detect tags in entries" do
      s = sample_entry
      s.entry_text = <<-end
# Sample document

#Heading

This document tests our ability to detect tags like #foo and #bar, and even #baz! But #foo2012 and #bar_3 should still be accepted. This#antifoo should not.
end
      s.add_tags_from_entry_text
      %w(foo bar baz foo2012 bar_3).each do |t|
        s.tags.should include(t)
      end
      s.tags.should_not include('antifoo')
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