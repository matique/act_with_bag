HH = "#" * 22 unless defined?(HH)
H = "#" * 5 unless defined?(H)

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
  when "test" then run %(bundle exec ruby -I test #{file})
  #  when 'spec';  run %(rspec -X #{file})
  else; puts "#{H} unknown type: #{type}, file: #{file}"
  end
end

def run_all_tests
  puts "\n#{HH} Running all tests #{HH}\n"
  %w[test spec].each { |dir| run "bundle exec rake #{dir}" if File.exist?(dir) }
end

def run_matching_files(base)
  base = base.split("_").first
  %w[test spec].each { |type|
    files = Dir["#{type}/**/*.rb"].select { |file| file =~ /#{base}_.*\.rb/ }
    run_it type, files.join(" ") unless files.empty?
  }
end

%w[test spec].each { |type|
  watch("#{type}/#{type}_helper\.rb") { run_all_tests }
  watch('lib/.*\.rb') { run_all_tests }
  watch("#{type}/.*/*_#{type}\.rb") { |match| run_it type, match[0] }
}

# Ctrl-\ or ctrl-4
Signal.trap("QUIT") { run_all_tests }
# Ctrl-C
Signal.trap("INT") { abort("Interrupted\n") }
usage
