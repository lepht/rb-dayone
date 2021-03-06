#encoding: UTF-8

require './spec/spec_helper'

describe DayOne::EntryImporter do
  let(:sample_entry){ DayOne::EntryImporter::from_file spec_data('sample.doentry') }
  
  describe "#initialize" do
    it "should accept a string or file" do
      ei = DayOne::EntryImporter.new('foo')
      ei.data.should == 'foo'
      
      file_ei = DayOne::EntryImporter::from_file spec_data('foo.doentry')
      file_ei.data.should == 'foo'
    end
  end

  describe "#processed_data" do
    let(:data){ DayOne::EntryImporter.from_file spec_data('entry_importer_parse_test.xml')  }

    it "should accept strings" do
      data['String test'].should eq('Sample string')
    end

    it "should accept reals" do
      data['Real test'].should eq(3.141)
    end

    it "should accept dates" do
      data['Date test'].year.should eq(1997)
    end

    it "should accept booleans" do
      data['Bool test'].should be_true
      data['Bool test 2'].should be_false
    end

    it "should accept arrays" do
      arr = data['Array test']
      arr.should be_a(Array)
      arr.size.should eq(2)
      arr[0].should eq('A string')
      arr[1].should eq(1.234)
    end

    it "should accept dictionaries" do
      dict = data['Dict test']
      dict.should be_a(Hash)
      dict.keys.size.should eq(1)
      dict['Sample dict key'].should eq(2.345)
    end
  end
  
  describe "#[]" do
    
    def wrap str
      <<-end
<plist>
  <dict>
    <key>element</key>
    <string>#{str}</string>
  </dict>
</plist>
      end
    end
    
    it "should accept ampersands" do
      importer = DayOne::EntryImporter.new(wrap('&amp;'))
      importer['element'].should == '&'
    end
    
    it "should accept UTF-8" do
      importer = DayOne::EntryImporter.new(wrap('æ'))
      importer['element'].should == 'æ'
    end
    
    it "should accept UTF-8 from file" do
      importer = DayOne::EntryImporter.from_file spec_data('utf.doentry')
      importer['Entry Text'].should == 'æ'
    end
  end
  
  describe "#to_entry" do
    it "should make a valid entry" do
      entry = sample_entry.to_entry
      entry.entry_text.should == 'Hello, world!'
      entry.starred.should be_true
      entry.creation_date.year.should == 1997
      entry.location.country.should == 'New Zealand'
      entry.should be_saved      
    end
  end
end