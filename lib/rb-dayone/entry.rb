# A text-only journal entry for DayOne.
class DayOne::Entry

  # The date of the journal entry
  attr_accessor :creation_date
  
  # The journal entry's body text
  attr_accessor :entry_text
  
  # Whether the entry has been starred
  attr_accessor :starred
  
  # Whether the entry has been saved to file at all.
  attr_accessor :saved
  
  # The PList doctype, used for XML export
  DOCTYPE = 'plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"'
  
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
    builder = Builder::XmlMarkup.new
    builder.instruct!                     # Basic xml tag
    builder.declare! :DOCTYPE, DOCTYPE   # PList doctype
    builder.plist(version:1.0) do
      builder.dict do
        builder.key 'Creation Date'
        builder.date creation_date.utc.iso8601
        
        builder.key 'Entry Text'
        builder.string entry_text
        
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
    builder.target
  end
  
  # Create a .doentry file with this entry.
  # This uses the #to_xml method to generate
  # the entry proper.
  # @return [Boolean] true if the operation was successful.
  def create!
    xml = self.to_xml
    file_location = File.join(DayOne::journal_location,'entries',"#{uuid}.doentry")
    File.open(file_location,'w'){ |io| io << xml }
    return true
  end
end