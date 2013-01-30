require './spec/spec_helper'

describe DayOne::Entry do
  before :all do
    setup_working
  end
  
  after :all do
    clean_working
  end

  describe "#image=" do
    it "should correctly record a path to the assigned image" do
      e = DayOne::Entry.new
      e.image = spec_data('/sample_image.jpg')
      e.image.should == spec_data('/sample_image.jpg')
    end

    it "should error if linked to a non-jpg image (for now)" do
      e = DayOne::Entry.new
      ->{ e.image = spec_data('/sample_image.png') }.should raise_error
    end

    it "should error if the linked image does not exist" do
      e = DayOne::Entry.new
      -> { e.image = 'nonexistant.jpg' }.should raise_error
    end

    it "should relocate the image when the entry is created" do
      e = DayOne::Entry.new
      e.image = spec_data('/sample_image.jpg')
      e.create!
      File.should exist(spec_data("working/photos/#{e.uuid}.jpg"))
    end
  end
  
end