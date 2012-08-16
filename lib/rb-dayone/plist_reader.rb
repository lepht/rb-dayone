require 'json'

# The PListReader is a class that reads PLists.
# It is used to read the DayOne preferences PList.
class DayOne::PlistReader
  
  # The path of the PList to read.
  attr_accessor :path
  
  # Initialize the PList Reader, given a path
  # @param [String] path the path to the PList; defaults to the standard DayOne preference plist
  def initialize path=nil
    @path = path || File.join(ENV['HOME'], 'Library', 'Preferences', 'com.dayoneapp.dayone.plist')
  end
  
  # Retrieve the body of the plist as an array, parsed through JSON
  # @return [Hash] the body of the plist as a hash.
  def body
    if !@body
      json_string = `plutil -convert json -o - '#{path}'`
      @body = JSON.parse(json_string)
    end
    @body
  end
  
  # This allows us to access the body's method as well as the reader's.
  def method_missing sym, *args
    if self.body.respond_to? sym
      self.body.send(sym, *args)
    else
      super sym, *args
    end
  end
end