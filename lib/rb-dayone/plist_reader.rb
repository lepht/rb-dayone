require 'json'

class DayOne::PlistReader
  attr_accessor :path
  
  def initialize path=nil
    @path = path || File.join(ENV['HOME'], 'Library', 'Preferences', 'com.dayoneapp.dayone.plist')
  end
  
  def body
    if !@body
      json_string = `plutil -convert json -o - '#{path}'`
      @body = JSON.parse(json_string)
    end
    @body
  end
  
  def method_missing sym, *args
    if self.body.respond_to? sym
      self.body.send(sym, *args)
    else
      super sym, *args
    end
  end
end