gem_title = 'rb-dayone'

def pkg
  p = Dir['pkg/*.gem'].sort[-1]
  if p.nil?
    $stderr.puts "ERROR: Can't find pkg file."
  else
    p
  end
end

task :build do
  specfile = "#{gem_title}.gemspec"
  puts `gem build '#{specfile}'`
  
  gem_file = Dir["#{gem_title}-*.gem"]
  gem_file.each do |f|
    puts `mv '#{f}' pkg`
  end
end

task :install => [:build] do
  puts `gem install #{pkg}`
end

task :push => [:build] do
  puts `gem push #{pkg}`
end

task :spec do
  puts `rspec`
end

task :default => :spec