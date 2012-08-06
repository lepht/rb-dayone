=begin
  This class allows for the creation of simple XML files.
  
  == Example of use
  
    e = DayOne::Entry.new
    xml = DayOne::SimpleXML.new(e) do
      plist version:1.0 do
        dict do
          key 'Creation Date'
          date my.creation_date
        end
      end
    end
  
  Will produce:
  
    <?xml version="1.0" encoding="UTF-8"?>
    <plist version="1.0">
      <dict>
        <key>Creation Date</key>
        <date>2012-08-05 21:28:27 +1200</date>
      </dict>
    </plist>
  
  == How it works
  
  * Use DayOne::SimpleXML.new(object) to create a
    SimpleXML instance bound to +object+.
  * Add a block to this.
    * In this block, use the #tag method to generate tags
    * Alternatively, use #method_missing to auto-generate tags
  * Call #to_s to get an XML string
=end
class DayOne::SimpleXML
  
  # The XML body
  attr_accessor :body
  
  # The object attached to this instance
  attr_reader :my
  
  # Initialize the XML instance with:
  # * +object+: An object bound to the instance, accessible within the block using
  #   the +my+ method.
  # * +block+: A block to be run inside the XML instance
  
  def initialize object=nil, &block
    @my=object

    opts = {
      version: '1.0',
      encoding: 'UTF-8'
    }    
    opts_string = stringify_hash(opts)
    
    @body = "<?xml #{opts_string}?>\n"
    @indent = 0
    instance_eval(&block)
  end
  
  # Declare a simple, non-xml-compliant tag
  # ==Example
  #   declare '!DOCTYPE html5'
  # Will give:
  #   <!DOCTYPE html5>
  def declare name, options={}
    stringed_options = stringify_hash(options)
    name_and_options = "#{name} #{stringed_options}".strip
    cat "<#{name_and_options}>"
  end
  
  # Create a tag, with a variety of arguments
  # 
  # If a block is passed to the tag, it will be
  # processed and inserted in the tag.
  # 
  # If a string is passed (and no block is passed),
  # the string will be inserted in the tag.
  #
  # If both a block and a string are passed,
  # the block will be evaluated and the string
  # ignored.
  #
  # If a hash is passed, it will be used to generate
  # string options for the tag.
  #
  # The order of string and hash is not important.
  #
  # ==Examples
  #
  #   tag 'foo', 'bar' # => <foo>bar</foo>
  #   tag 'foo', option:bar #=> <foo option="bar" />
  # 
  def tag name, *args
    # Basically, args could contain a hash and/or a string
    options = args.find{ |elem| elem.is_a? Hash } || {}
    contents = args.find{ |elem| elem.is_a? String } || nil
    
    stringed_options = stringify_hash(options)
    name_and_options = "#{name} #{stringed_options}".strip
    
    case true
    when block_given? # We ignore the string in this case
      cat "<#{name_and_options}>"
      @indent += 2
      yield
      @indent -= 2
      cat "</#{name}>"
    when !contents.nil?     # No block, let's fall back on the string
      cat "<#{name_and_options}>#{contents}</#{name}>"
    else              # No block or string - open and shut case
      cat "<#{name_and_options} />"
    end
  end

  # All methods not recognised by the Entry class
  # will be converted to tags, for ease of use.
  # == Examples
  #   dict #=> tag :dict
  #   foo bar:3 #=> tag :foo, bar:3
  def method_missing sym, *args, &block
    tag sym, *args, &block
  end
  
  # Outputs the XML as a string
  def to_s
    @body
  end
  
  private
  def cat str
    @body << "#{' '*@indent}#{str}\n"
  end
   
  def stringify_hash options
    options.map{ |k,v| "#{k}=\"#{v.to_s.gsub('"','\"')}\""}.join(' ')
  end
end