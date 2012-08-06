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
  
  DOCTYPE = '!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"' # :nodoc:
  
  # Initialise with a hash of values - #creation_date, #entry_text and #starred
  def initialize hsh={}
    # Some defaults
    @creation_date = Time.now
    @starred = false
    @entry_text = ''
    
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
    DayOne::SimpleXML.new(self) do
      declare DOCTYPE
      plist version: 1.0 do
        dict do
          key 'Creation Date'
          date my.creation_date.utc.iso8601
          key 'Entry Text'
          string my.entry_text
          key 'Starred'
          tag(my.starred ? 'true' : 'false')
          key 'UUID'
          string my.uuid
        end
      end
    end.to_s
  end
  
  # Create a .doentry file with this entry.
  # This uses the #to_xml method to generate
  # the entry proper.
  def create!
    xml = self.to_xml
    file_location = File.join(DayOne::JOURNAL_LOCATION,'entries',"#{uuid}.doentry")
    File.open(file_location,'w'){ |io| io.puts xml }
  end
end