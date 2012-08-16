require './lib/rb-dayone'

def spec_data *path
  File.join(File.dirname(__FILE__), 'data', *path)
end