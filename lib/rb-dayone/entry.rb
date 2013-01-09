require 'libxml'
require 'fileutils'

# A text-only journal entry for DayOne.
class DayOne::Entry

  # A list of image extensions allowed for attached images
  ALLOWED_IMAGES = ['.jpg','.jpeg']

  # The date of the journal entry
  attr_accessor :creation_date
  
  # The journal entry's body text
  attr_accessor :entry_text
  
  # Whether the entry has been starred
  attr_accessor :starred
  
  # Whether the entry has been saved to file at all.
  attr_accessor :saved

  # Path to the entry image
  attr_accessor :image

  # An entry's tags
  attr_accessor :tags
  
  # The PList doctype, used for XML export
  DOCTYPE = [:DOCTYPE, :plist, :PUBLIC, "-//Apple//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd"]
  
  # Initialise a journal entry, ready for inclusion into your journal
  # @param [String] entry_text the body text of the journal entry
  # @param [Hash] hsh a hash of options - allowed keys include `:creation_date`, `:entry_text` and `:starred`, others are ignored
  # @return [DayOne::Entry] the journal entry
  def initialize entry_text='', hsh={}
    # Some defaults
    @creation_date = Time.now
    @starred = false
    @entry_text = entry_text
    @saved = false
    @tags = []
    
    hsh.each do |k,v|
      setter = "#{k}="
      self.send(setter,v) if self.respond_to? setter
    end
  end
  
  # Generate (or retrieve, if previously generatred) a UUID
  # for this entry.
  # @return [String] the entry's UUID
  def uuid
    @uuid ||= `uuidgen`.gsub('-','').strip
  end
  
  # The same as calling Entry#saved
  def saved?
    saved
  end
  
  # Convert an entry to XML.
  # @return [String] the entry as XML
  def to_xml
    builder = Builder::XmlMarkup.new(indent:2)
    builder.instruct!                     # Basic xml tag
    builder.declare! *DOCTYPE   # PList doctype
    builder.plist(version:1.0) do
      builder.dict do
        builder.key 'Creation Date'
        builder.date creation_date.utc.iso8601
        
        builder.key 'Entry Text'
        builder.string entry_text

        if !tags.empty?
          builder.key 'Tags'
          builder.array do
            tags.each do |t|
              builder.string t
            end
          end
        end
        
        builder.key 'Starred'
        if starred
          builder.true
        else
          builder.false
        end
        
        builder.key 'UUID'
        builder.string uuid
      end
    end
    builder.target!
  end
  
  # Create a .doentry file with this entry.
  # This uses the #to_xml method to generate the entry proper.
  # It will also relocate its attached image, if required.
  # @return [Boolean] true if the operation was successful.
  def create!
    xml = self.to_xml
    file_location = File.join(DayOne::journal_location,'entries',"#{uuid}.doentry")
    File.open(file_location,'w'){ |io| io << xml }
    if image
      new_image_path = File.join(DayOne::journal_location, 'photos', "#{uuid}.jpg")
      FileUtils.cp(image, new_image_path)
      @image = new_image_path
    end
    return true
  end
  
  # Check to make sure that we output valid xml
  def xml_valid?
    LibXML::XML::Error.set_handler(&LibXML::XML::Error::QUIET_HANDLER)
    begin
      LibXML::XML::Parser.string(to_xml).parse
    rescue LibXML::XML::Error
      return false
    else
      return true
    end
  end

  # Assign an image to the entry
  # For now, this will only accept jpeg images (extension is 'jpg' or 'jpeg', case-insensitive)
  # Later, may support conversion via the appropriate library
  # @param image_path [String] the path to the image
  def image= image_path
    if !File.exists?(image_path)
      raise RuntimeError, "Tried to link a journal entry to the image #{image_path}, but it doesn't exist."
    elsif image_path =~ /\.[^.]+$/ && ALLOWED_IMAGES.include?($&.downcase)
      @image = image_path
    else
      raise RuntimeError, "Tried to link a journal entry to the image #{image_path}, but it's not a supported image format (#{ALLOWED_IMAGES.join(", ")})."
    end
  end
end