# This represents a location as recognised by DayOne.app
class Location

  # The country this post was made in
  attr_accessor :country

  # The locality this post was made in
  attr_accessor :locality

  # The administrative area this post was made in
  attr_accessor :administrative_area

  # The place this post was made at
  attr_accessor :place_name
  
  # The latitude this post was made at. Saved as a +real+ to XML.
  attr_accessor :latitude

  # The longitude this post was made at. Saved as a +real+ to XML.
  attr_accessor :longitude

  # Initialize the location with a hash of values.
  # @param [Hash] hsh The values to be assigned on initalization
  def initialize hsh={}
    hsh.each do |k,v|
      setter = "#{k}="
      send(setter,v) if respond_to?(setter)
    end
  end

  # Create a location from an XML snippet.
  # @param [Nokogiri::Node] element The XML element (<dict> contents) that contains the location data
  # @return [Location] The location formed from this data
  def self.from_xml element
    raise RuntimeError, "Not yet implemented"
  end
    
  # Converts the location to xml. A +builder+ must be supplied, and
  # this method will run operations on the builder and return
  # a boolean indicating its success.
  # @param [Builder] builder The builder this object will be put in
  # @return [bool] The success of the operation
  def to_xml builder
    builder.key 'Location'
    builder.dict do
      builder.key 'Country'
      builder.string country
      
      builder.key 'Administrative Area'
      builder.string administrative_area
      
      builder.key 'Locality'
      builder.string locality

      builder.key 'Place Name'
      builder.string place_name

      builder.key 'Latitude'
      builder.real latitude.to_f

      builder.key 'Longitude'
      builder.real longitude.to_f
    end
    true
  end
end
