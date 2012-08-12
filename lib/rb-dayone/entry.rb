# An entry is any entry for DayOne.
# At this stage you can't edit, modify,
# view or delete existing entries, just
# create new entries.
class DayOne::Entry

  # The date the journal entry will be created with
  attr_accessor :creation_date
  
  # The text of the journal itself (markdown allowed)
  attr_accessor :entry_text
  
  # Whether the entry has been starred
  attr_accessor :starred
  
  DOCTYPE = 'plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"' # :nodoc:
  
  # Make the new entry. Note that the entry won't be inserted into your journal until you
  # call DayOne#create!
  # DayOne.new takes a string for the journal entry, and a hash that may set any attributes.
  def initialize entry_text='', hsh={}
    # Some defaults
    @creation_date = Time.now
    @starred = false
    @entry_text = entry_text
    
    hsh.each do |k,v|
      setter = "#{k}="
      self.send(setter,v) if self.respond_to? setter
    end
  end
  
  # Generate (or retrieve, if previously generatred) a UUID
  # for this entry.
  def uuid
    @uuid ||= `uuidgen`.gsub('-','').strip
  end
  
  # Convert an entry to xml, using
  # DayOne::SimpleXML
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
  def create!
    xml = self.to_xml
    file_location = File.join(DayOne::journal_location,'entries',"#{uuid}.doentry")
    File.open(file_location,'w'){ |io| io << xml }
  end
end