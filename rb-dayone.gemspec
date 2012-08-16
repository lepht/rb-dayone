# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rb-dayone"
  s.version = File.read('version.txt')
  
  s.summary = "Create DayOne journal entries in ruby."
  s.description = "Create [DayOne](http://www.dayoneapp.com) journal entries simply and easily in ruby. Currently only supports text entries, image entries to come."
  
  s.author = 'Jan-Yves Ruzicka'
  s.email = 'janyves.ruzicka@gmail.com'
  s.homepage = 'https://github.com/jyruzicka/rb-dayone'
  
  s.files = File.read('Manifest').split("\n")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'dayone'
  s.extra_rdoc_files = ['README.md']
  
  s.add_runtime_dependency 'builder', '~> 2.0'
  s.add_runtime_dependency 'commander', '~> 4.1.2'
  s.add_runtime_dependency 'libxml-ruby', '~> 2.3.3'
end
