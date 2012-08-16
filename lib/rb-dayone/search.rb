# A search of the database.
# Create this object with Search.new. Give it some parameters to search for, then
# simple use Search#[] to access results.
class DayOne::Search
  attr_accessor :entry_text, :starred
  
  def initialize hash={}
    @entry_text = ''
    hash.each do |k,v|
      setter = "#{k}="
      self.send(setter, v) if self.respond_to?(setter)
    end
  end
  
  def results
    if !@results
      @results = []
      working_results = cache

      working_results = working_results.select{ |e| e.entry_text.include? entry_text } unless entry_text == ''
      working_results = working_results.select{ |e| e.starred == starred } unless starred.nil?
      
      @results = working_results
    end
    @results
  end
  
  def [] index
    results[index]
  end
  
  private
  
  # Caches all journal entries for us. On first running, will load everything
  # from file. After this, will just refer back to the cache.
  # @return [Array] an array of DayOne::Entry objects
  def cache
    if !@cache
      entries = File.join(DayOne::journal_location, 'entries', '*.doentry')
      @cache = Dir[entries].map{ |e| DayOne::EntryImporter::from_file(e).to_entry }
    end
    @cache
  end
end