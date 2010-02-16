require 'rubygems'
require 'rake'

begin
  require 'echoe'

  Echoe.new('act_with_bag', '1.1.0') do |p|
    p.summary         = "Bag for AR"
    p.description     = "Handles multiple fields in one YAML bag in AR"
    p.url             = "http://github.com/<...>/act_with_bag"
    p.author          = "Dittmar Krall"
    p.email           = "dittmar.krall@matique.de"
    p.ignore_pattern  = ['tmp/*', '*.tmp', '*.bak']
    p.development_dependencies = []
  end

  Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."

  # if you still want tests when Echoe is not present
  desc 'Run the test suite.'
  task :test do
    system "ruby -Ibin:lib:test some_tests_test.rb" # or whatever
  end
end
