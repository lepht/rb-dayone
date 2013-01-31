# This represents a location as recognised by DayOne.app
class DayOne::Location

  # An array of components that make up the location
  STRING_COMPONENTS = [:country, :locality, :administrative_area, :place_name]
  REAL_COMPONENTS = [:latitude, :longitude]
  ALL_COMPONENTS = STRING_COMPONENTS + REAL_COMPONENTS

  # These are all instance variables
  attr_accessor *ALL_COMPONENTS

  # Initialize the location with a hash of values.
  # @param [Hash] hsh The values to be assigned on initalization
  def initialize hsh=nil
    if hsh
      hsh.each do |k,v|
        setter = "#{symbol(k)}="
        send(setter,v) if respond_to?(setter)
      end
    end
  end

  # Has this location been left blank?
  # @return [bool] If any value in this instance is not nil or blank
  def left_blank?
    STRING_COMPONENTS.all?{ |s| [nil,''].include?(send(s)) } &&
    REAL_COMPONENTS.all?{ |s| [nil,0.0].include?(send(s)) }
  end
    
  # Converts the location to xml. A +builder+ must be supplied, and
  # this method will run operations on the builder and return
  # a boolean indicating its success.
  # @param [Builder] builder The builder this object will be put in
  # @return [bool] The success of the operation
  def to_xml builder
    builder.key 'Location'
    builder.dict do
      STRING_COMPONENTS.each do |s|
        builder.key xml_string(s)
        builder.string send(s)
      end

      REAL_COMPONENTS.each do |s|
        builder.key xml_string(s)
        builder.real send(s)
      end
    end
    true
  end

  private

  # Gives the XML string for a particular symbol
  # @param [Symbol] symbol The symbol to find the XML string for
  # @return [String] The string for this symbol
  def xml_string symbol
    if symbol.is_a? String
      symbol
    else
      symbol.to_s.gsub('_',' ').gsub(/\b./, &:upcase)
    end
  end

  # Gives the symbol for a particular XML string
  # @param [String] string The XML string to find the symbol for
  # @return [Symbol] The symbol for this symbol
  def symbol xml_string
    if xml_string.is_a? Symbol
      xml_string
    else
      xml_string.downcase.gsub(' ','_').intern
    end
  end
end
