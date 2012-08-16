require 'rexml/document'

# Imports DayOne entries from XML files or plain text
class DayOne::EntryImporter
  
  # Raw data as provided in initialize
  attr_accessor :data
  
  # File (if supplied)
  attr_accessor :file
  
  # Create a new entry based on a string. To import from a file,
  # use EntryImporter.from_file
  # @param [String] data The raw data for the importer to process
  def initialize data
    @data = data
  end
  
  # Create a new entry from a file
  # @param [String] file The file to import
  def self.from_file file
    ei = new(File.read(file))
    ei.file = file
    ei
  end
  
  # Access entry data by key
  # @param [String, Symbol] key The key to retrieve 
  # @return the value stored in the file, or nil
  def [] key
    processed_data[key]
  end
  
  # Generate and return the data contained within the doentry file, as a hash
  # @return [Hash] the processed data
  def processed_data
    if !@processed_data
      @processed_data = {}
      begin
        xml = REXML::Document.new(data)
        key = nil
        xml.root.elements.each('/plist/dict/*') do |elem|
          case elem.name
          when 'key'
            key = elem.text
          when 'date'
            if elem.text =~ /(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)Z/
              @processed_data[key] = Time.new($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
            end
          when 'true'
            @processed_data[key] = true
          when 'false'
            @processed_data[key] = false
          else
            @processed_data[key] = elem.text
          end
        end
      rescue REXML::ParseException
        $stderr.puts "#{file ? "File #{file}" : "Data"} was malformed, and could not be read. Skipping."
        @processed_data = {}
      end
    end
    @processed_data
  end
  
  # Generate an entry from this importer
  # @return a DayOne::Entry based on this importer
  def to_entry
    DayOne::Entry.new(
      self['Entry Text'],
      starred: self['Starred'],
      creation_date: self['Creation Date'],
      saved: true
    )
  end
end