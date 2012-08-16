require './spec/spec_helper'
require 'fileutils'

describe DayOne::Entry do
  before :each do
    FileUtils::mkdir_p spec_data('working/entries')
  end
  
  after :each do
    FileUtils::rm_rf spec_data('working')
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
  end
  
  describe "#create!" do
    it "should correctly create a .doentry file" do
      
      DayOne::journal_location = spec_data('working')
      
      e = subject
      e.entry_text = "Hello, world!"
      e.create!
      
      file_location = Dir[spec_data('working', 'entries', '*.doentry')][0]
      file_location.should_not be_nil
      
      contents = File.read(file_location)
      contents.should == e.to_xml
    end
  end
end