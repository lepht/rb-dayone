require 'time'

# This module contains all classes used in the DayOne module
module DayOne
  class << self
    # This is where all DayOne-relevant information is stored.
    # Set by default to ~/.rb-dayone
    attr_accessor :dayone_folder
  
    # This is where your DayOne Journal is kept. Modify either
    # by directly modifying the ~/.rb-dayone/location file
    # (not recommended) or by running `dayone --set location`
    # (recommended)
    def journal_location
      @journal_location ||= File.read(journal_file)
    end
    
    # Error-checking method. Ensures that the journal location
    # file exists.
    def journal_location_exists?
      File.exists? journal_file
    end
    
    private
    
    # The journal file location
    def journal_file
      @journal_file ||= File.join(dayone_folder, 'location')
    end
  end
end

DayOne::dayone_folder = File.join(ENV['HOME'], '.rb-dayone')

unless DayOne::journal_location_exists?
  puts <<-end
Error: DayOne journal file has not been located.
Please set this using the command `dayone --set location
before continuing.
  end
end

# :stopdoc:

LIBPATH = File.dirname(File.expand_path(__FILE__))
Dir[File.join(LIBPATH, 'rb-dayone', '*.rb')].each{ |f| require f }

# :startdoc: