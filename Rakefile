gem_title = 'rb-dayone'

task :build do
  specfile = "#{gem_title}.gemspec"
  puts `gem build '#{specfile}'`
  
  gem_file = Dir["#{gem_title}-*.gem"]
  gem_file.each do |f|
    puts `mv '#{f}' pkg`
  end
end

task :install do
  pkg = Dir['pkg/*.gem'].sort[-1]
  puts `gem install #{pkg}`
end

task :go => [:build, :install] do
end

task :default => :go