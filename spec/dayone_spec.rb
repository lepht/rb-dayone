require './spec/spec_helper'

describe DayOne do
  describe "#journal_location" do
    
    before(:each) do
      DayOne::journal_location = nil
      DayOne::instance_variable_set('@journal_file',nil)
    end
    
    def location str
      spec_data("locations", "location-#{str}")
    end
    
    it "should return the value given by the +location+ file" do
      DayOne::dayone_folder = location('specified')
      DayOne::journal_location.should == 'sample location'
    end
    
    it "should return a default value when +location+ is 'auto'" do
      reader = double('ReaderMock')
      reader.should_receive(:journal_location).and_return('foo')
      DayOne.plist_reader = reader
      DayOne::dayone_folder = location('auto')
      DayOne::journal_location.should == File.expand_path('foo')
    end
    
    it "should return a default value if +location+ doesn't exist" do
      DayOne.plist_reader = {'NSNavLastRootDirectory' => 'foo'}
      DayOne::dayone_folder = location('unspecified')
      DayOne::journal_location.should == File.expand_path('foo')
    end
  end
end