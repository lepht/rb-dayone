# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rb-dayone"
  s.version = File.read('version.txt')
  
  s.summary = "Create DayOne journal entries in ruby."
  s.description = "Create or search [DayOne](http://www.dayoneapp.com) journal entries simply and easily in ruby. Currently only supports text entries, image entries to come."
  
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
  
  s.post_install_message = <<-end
#{'-'*80}
Hi there! If you're upgrading from version <= 0.2.0 of this gem, I've been a
horrid dev and let a few bugs through in my XML building code. In order to fix
this, you can run `dayone verify` to see if your database needs fixing. If any 
of the errors are my fault, you should be able to fix them with `dayone
repair`.

Sorry if this has caused any inconvenience. If you still have trouble repairing
any of your .doentry files, send me an email and I'll see what I can do to
help.
#{'-'*80}
  end
end
