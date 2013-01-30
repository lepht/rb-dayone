# Imports DayOne entries from XML files or plain text
class DayOne::EntryImporter
  
  # Raw data as provided in initialize
  attr_accessor :data
  
  # File (if supplied)
  attr_accessor :file
  
  # Create a new entry based on a string. To import from a file,
  # use EntryImporter.from_file.
  # @param [String] data The raw data for the importer to process
  # @param [String] file The file this data came from. Defaults to +nil+.
  def initialize data, file=nil
    @data = data
    @file = file
  end
  
  # Create a new entry from a file
  # @param [String] file The file to import
  def self.from_file file
    new(File.read(file), file)
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
        document = Nokogiri::XML(data)
        key = nil
        
        document.xpath('//plist/dict/*').each do |elem|
          case elem.name
          when 'key'
            key = elem.content
          when 'date'
            if elem.content =~ /(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)Z/
              @processed_data[key] = Time.utc($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
            end
          when 'true'
            @processed_data[key] = true
          when 'false'
            @processed_data[key] = false
          when 'array' # NOTE: This will only do string arrays currently
            @processed_data[key] = elem.children.select(&:element?).map{ |c| c.content }
          else
            @processed_data[key] = elem.content
          end
        end
      rescue LibXML::XML::Error
        $stderr.puts "Error parsing #{file ? "file #{file}" : "data"}. Skipping."
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
      saved: true,
      tags: self['Tags']||[]
    )
  end
end