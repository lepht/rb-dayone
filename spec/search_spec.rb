describe DayOne::Search do
  describe "#initialize" do
    it "should create a Search object, uninitialized" do
      subject.entry_text.should == ''
      subject.starred.should be_nil
    end
  end
  
  describe "#results" do
    before :all do
      DayOne::journal_location = spec_data
    end
    
    it "should find all posts when no search criteria are applied" do
      subject.results.size.should == 2
    end
    
    it "should find posts when searching by string" do
      search = DayOne::Search.new entry_text: 'foo'
      search.results.size.should == 1
      search[0].entry_text.should == "Yes, this is foo."
    end
    
    it "should find posts when searching by starred" do
      search = DayOne::Search.new starred:true
      search.results.size.should == 1
      search[0].entry_text.should == "Hello bar."
    end
    
    it "should find posts when searching by string and starred" do
      search = DayOne::Search.new entry_text: 'foo', starred:true
      search.results.should be_empty
    end
  end
end