require './spec/spec_helper'

describe DayOne::Search do
  describe "#initialize" do
    it "should create a Search object, uninitialized" do
       expect(subject.entry_text).to be_nil
       expect(subject.starred).to be_nil
    end
  end
  
  describe "#results" do
    before :all do
      DayOne::journal_location = spec_data
    end
    
    it "should find all posts when no search criteria are applied" do
       expect(subject.results.size).to eq(2)
    end
    
    it "should find posts when searching by string" do
      search = DayOne::Search.new entry_text: 'foo'
       expect(search.results.size).to eq(1)
       expect(search[0].entry_text).to eq("Yes, this is foo.")
    end

    it "should filter posts when searching by body and the string is elsewhere" do
      search = DayOne::Search.new entry_text: "true"
       expect(search.results.size).to eq(0)
    end
    
    it "should find posts when searching by starred" do
      search = DayOne::Search.new starred:true
       expect(search.results.size).to eq(1)
       expect(search[0].entry_text).to eq("Hello bar.")
    end
    
    it "should find posts when searching by string and starred" do
      search = DayOne::Search.new entry_text: 'foo', starred:true
       expect(search.results).to be_empty
    end

    it "should find posts when searching for tags" do
      search = DayOne::Search.new tag:'tag'
       expect(search.results.size).to eq(1)
      no_search = DayOne::Search.new tag:'does not exist'
       expect(no_search.results).to be_empty
    end

    it "should find posts after a given date" do
      time = Time.new(2012,1,1,1,1,1)
      search = DayOne::Search.new creation_date_after: time
      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq("Hello bar.")
    end

    it "should find posts before a given date" do
      time = Time.new(2012,1,1,1,1,1)
      search = DayOne::Search.new creation_date_before: time
      expect(search.results.size).to eq(1)
      expect(search.results.first.entry_text).to eq("Yes, this is foo.")
    end

    it "should find posts between given dates" do
      start_of_ten = Time.new(2010,1,1,1,1,1)
      start_of_eleven = Time.new(2011,1,1,1,1,1)
      start_of_twelve = Time.new(2012,1,1,1,1,1)
      start_of_thirteen = Time.new(2013,1,1,1,1,1)
      search1 = DayOne::Search.new(
        creation_date_before: start_of_twelve,
        creation_date_after: start_of_eleven
      )
      search2 = DayOne::Search.new(
        creation_date_before: start_of_eleven,
        creation_date_after: start_of_ten
      )

      expect(search1.results.size).to eq(1)
      expect(search1.results.first.entry_text).to eq("Yes, this is foo.")
      expect(search2.results).to be_empty
    end
  end
end