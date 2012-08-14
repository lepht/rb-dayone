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
  s.post_install_message = <<-end
#{'-'*80}
Thank you for installing rb-dayone!

To finish setup, run `dayone set location <location>` to specify where your DayOne journal is stored.
#{'-'*80}
  end
  
  s.add_runtime_dependency 'builder', '~> 2.0'
end
