# A search of the database.
# Create this object with Search.new. Give it some parameters to search for, then
# use Search#[] to access results.
class DayOne::Search
  
  # The entry must include this text
  attr_accessor :entry_text
  
  # The entry must be starred
  attr_accessor :starred

  # The entry must have this tag
  attr_accessor :tag

  # The entry must have been created after this time
  attr_accessor :creation_date_after

  # The entry must have been created before this time
  attr_accessor :creation_date_before
  
  # Initialize the search. Currently you can search by:
  # * entry text
  # * starred status
  # * tag
  # * creation date (before and after)
  def initialize(entry_text:nil, starred:nil, tag:nil,
    creation_date_before:nil, creation_date_after:nil)

    @entry_text           = entry_text
    @starred              = starred
    @tag                  = tag
    @creation_date_before = creation_date_before
    @creation_date_after  = creation_date_after
  end

  # Fetch the results by searching. Uses a cached version of the DayOne database.
  # @return [Array] all entries matching your results
  def results
    if !@results
      @results = []
      # We grub through results because scanning through Nokogiri takes ages
      @results = DayOne::entries.each_with_object({}){ |file, hash| hash[file] = File.read(file) }
      
      file_must_include = [entry_text, tag].compact
      @results = @results.select{ |k,v| file_must_include.all?{ |str| v.include?(str) } }

      # These are the checks on our entries
      verification_blocks = []

      verification_blocks << lambda do |v|
        v =~ %r|<key>Entry Text</key>\s+<string>(.*?)</string>|m && $1.include?(entry_text)
      end if entry_text

      verification_blocks << lambda do |v|
        v =~ %r|<key>Tags</key>\s+<array>(.*?)</array>|m && $1.include?("<string>#{tag}</string>")
      end if tag

      if !starred.nil?
        verification_blocks << if starred
          lambda{ |v| v =~ %r|<key>Starred</key>\s+<true/>| }
        else
          lambda{ |v| v =~ %r|<key>Starred</key>\s+<false/>| }
        end
      end

      if creation_date_after && creation_date_before
        verification_blocks << lambda do |v|
          t = Time.parse v[%r|<key>Creation Date</key>\s+<date>(.*?)</date>|]
          t && t.between?(creation_date_after, creation_date_before)
        end
      elsif creation_date_after
        verification_blocks << lambda do |v|
          t = Time.parse v[%r|<key>Creation Date</key>\s+<date>(.*?)</date>|]
          t && t > creation_date_after
        end
      elsif creation_date_before
        verification_blocks << lambda do |v|
          t = Time.parse v[%r|<key>Creation Date</key>\s+<date>(.*?)</date>|]
          t && t < creation_date_before
        end
      end

      @results = @results.select{ |k,v| verification_blocks.all?{ |b| b[v] } }
      @results = @results.map{ |file,data| DayOne::EntryImporter.new(data,file).to_entry }
    end
    @results
  end
  
  # Fetches a particular result
  # @param [Integer] index the index of the result to fetch
  # @return [DayOne::Entry] the entry
  def [] index
    results[index]
  end
end