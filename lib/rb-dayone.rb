require 'time'
require 'builder'

# This module contains all classes used in the DayOne gem,
# as well as some helper methods
module DayOne
  class << self
    # This is where all DayOne-relevant information is stored.
    # Set by default to ~/.rb-dayone
    attr_accessor :dayone_folder
    
    # The location of the DayOne journal file.
    attr_writer :journal_location
    
    # An interface to the propertylist reader
    attr_accessor :plist_reader
  
    # The location of the DayOne journal file.
    # If the location is set to "auto" or is non-existant,
    # will set from the DayOne plist (See +auto_journal_location+).
    # @return [String] the DayOne journal location
    def journal_location
      if !@journal_location 
        if File.exists?(journal_file)
          contents = File.read(journal_file)
          @journal_location = if contents == 'auto'
            auto_journal_location
          else
            contents
          end
        else
          @journal_location = auto_journal_location
        end
      end
      @journal_location
    end
    
    # The location of the DayOne journal file as determined by
    # the DayOne plist file stored in +~/Library/Preferences+.
    # @return [String] the DayONe journal location
    def auto_journal_location
      @auto_journal_location ||= plist_reader['NSNavLastRootDirectory']
    end
    
    private
    
    # The journal file location
    # @return [String] the location of the journal file
    def journal_file
      @journal_file ||= File.join(dayone_folder, 'location')
    end
  end
end

lib_root = File.dirname(__FILE__)
Dir[File.join(lib_root, "rb-dayone", "*.rb")].each{ |f| require f }

# Default values
DayOne::dayone_folder = File.join(ENV['HOME'], '.rb-dayone')
DayOne::plist_reader = DayOne::PlistReader.new