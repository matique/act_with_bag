HH = '#' * 22  unless defined?(HH)
H = '#' * 5    unless defined?(H)

def usage
  puts <<-EOS
  Ctrl-\\ or ctrl-4   Running all tests
  Ctrl-C             Exit
  EOS
end

def run(cmd)
  puts "#{HH} #{Time.now} #{HH}"
  puts "#{H} #{cmd}"
  system "/usr/bin/time --format '#{HH} Elapsed time %E' #{cmd}"
end

def run_it(type, file)
  case type
#  when 'test';  run %Q{ruby -I"lib:test" -rubygems #{file}}
  when 'test';  run %Q{rails test #{file}}
#  when 'spec';  run %Q{spring rspec -X #{file}}
  else;         puts "#{H} unknown type: #{type}, file: #{file}"
  end
end

def run_all_tests
  puts "\n#{HH} Running all tests #{HH}\n"
#  %w{test spec}.each { |dir| run "spring rake #{dir} RAILS_ENV=test"  if  File.exists?(dir) }
#  %w{test}.each { |dir| run "spring rake #{dir} RAILS_ENV=test"  if  File.exists?(dir) }
  %w{test}.each { |dir| run "rake #{dir} RAILS_ENV=test"  if  File.exists?(dir) }
end

def run_matching_files(base)
  base = base.split('_').first
  %w{test spec}.each { |type|
    files = Dir["#{type}/**/*.rb"].select { |file| file =~ /#{base}_.*\.rb/ }
    run_it type, files.join(' ')  unless files.empty?
  }
end

%w{test spec}.each { |type|
  watch("#{type}/#{type}_helper\.rb") { run_all_tests }
  watch("#{type}/.*/*_#{type}\.rb")   { |match| run_it type, match[0] }
}
%w{rb erb haml slim}.each { |type|
  watch("app/.*/.*\.#{type}") { |m|
    run_matching_files("#{m[0].split('/').at(2).split('.').first}")
  }
}

# Ctrl-\ or ctrl-4
    Signal.trap('QUIT') { run_all_tests }
# Ctrl-C
    Signal.trap('INT')  { abort("Interrupted\n") }
usage
