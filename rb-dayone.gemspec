# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rb-dayone"
  s.version = File.read('version.txt')
  
  s.summary = "Create DayOne journal entries in ruby."
  s.description = <<-end
  require 'rb-dayone'
  e = DayOne::Entry.new "Hello, world!"
  e.starred = true
  e.create!
  end
  
  s.author = 'Jan-Yves Ruzicka'
  s.email = 'janyves.ruzicka@gmail.com'
  s.homepage = 'http://www.rubygems.org/rb-dayone'
  
  s.files = Dir['lib/**.*.rb'] +
            Dir['bin/*'] +
            Dir['[A-Z]*'] + 
            Dir['spec/**/*']
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'dayone'
  s.extra_rdoc_files = ['README.md']
  s.post_install_message = <<-end
#{'-'*80}
Thank you for installing rb-dayone!

To finish setup, run `dayone --set location <location>` to specify where your DayOne journal is stored.
#{'-'*80}
  end
  
  
  
  s.add_runtime_dependency 'builder', '~> 2.0'
end
