require 'time'

# This module contains all classes used in the DayOne module
module DayOne
  DAYONE_FOLDER = File.join(ENV['HOME'],'.rb-dayone') #:nodoc:
  
  # Stored in ~/.rb-dayone/journal_location, this file
  # tells us where DayOne's journal is kept
  LOCATION_FILE = File.join(DAYONE_FOLDER, 'journal_location')
  
  if File.exists?(LOCATION_FILE)
    # This is the actual location of the DayOne Journal file
    JOURNAL_LOCATION = File.read(LOCATION_FILE)
  else
    puts "Error: DayOne journal file has not been located."
    puts "Please set this using the command `dayone --set <PATH>`"
    puts "before continuing."
    exit 1
  end
end

# :stopdoc:

LIBPATH = File.dirname(File.expand_path(__FILE__))
Dir[File.join(LIBPATH, 'rb-dayone', '*.rb')].each{ |f| require f }

# :startdoc: