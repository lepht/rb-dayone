require './spec/spec_helper'
require 'fileutils'

describe DayOne::Entry do
  
  let(:entry){ DayOne::Entry.new }
  
  after do
    Dir['spec/entries/*.doentry'].each{ |f| FileUtils.rm(f) }
  end
  
  describe "#to_xml" do
    it "should give a default entry" do
      e = entry.to_xml
      e.should match %r|<key>Entry Text</key>\s*<string></string>|
      e.should match %r|<key>Starred</key>\s*<false/>|
    end
    
    it "should set from initialize" do
      e = DayOne::Entry.new 'foo', starred:true
      e.starred.should be_true
      e.entry_text.should == 'foo'
    end
    
    it "should act properly when starred" do
      e = DayOne::Entry.new('foo', starred:true).to_xml
      e.should match %r|<key>Starred</key>\s*<true/>|
    end
  end
  
  describe "#create!" do
    it "should correctly create a .doentry file" do
      DayOne::journal_location = 'spec'
      FileUtils::mkdir_p 'spec/entries'
      
      e = entry
      e.entry_text = "Hello, world!"
      e.create!
      
      file_location = Dir['spec/entries/*.doentry'][0]
      file_location.should_not be_nil
      
      contents = File.read(file_location)
      contents.should == e.to_xml
    end
  end
end