# A search of the database.
# Create this object with Search.new. Give it some parameters to search for, then
# simple use Search#[] to access results.
class DayOne::Search
  
  # The entry must include this text
  attr_accessor :entry_text
  
  # The entry must be starred
  attr_accessor :starred
  
  # Initialize the search. Currently you can only search by entry text and starred status,
  # but both of these can be passed in via hash.
  # @param [Hash] hash a hash of search criteria, including:
  #   * +entry_text+: Text that the entry must include
  #   * +starred+: whether the entry is starred or not
  def initialize hash={}
    @entry_text = ''
    hash.each do |k,v|
      setter = "#{k}="
      self.send(setter, v) if self.respond_to?(setter)
    end
  end
  
  # Fetch the results by searching. Uses a cached version of the DayOne database.
  # @return [Array] all entries matching your results
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
  
  # Fetches a particular result
  # @param [Integer] index the index of the result to fetch
  # @return [DayOne::Entry] the entry
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