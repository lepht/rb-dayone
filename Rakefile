
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'rb-dayone'
  authors  'Jan-Yves Ruzicka'
  email    'janyves.ruzicka@gmail.com'
  url      'http://www.rubygems.org/rb-dayone'
}

