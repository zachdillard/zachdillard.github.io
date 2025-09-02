require 'rake/testtask'

# Default task runs all tests
task default: :test

# Define test task
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

# Individual test tasks for specific components
namespace :test do
  desc "Run configuration tests"
  Rake::TestTask.new(:config) do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_config.rb']
    t.verbose = true
  end
  
  desc "Run template tests"
  Rake::TestTask.new(:templates) do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_templates.rb']
    t.verbose = true
  end
  
  desc "Run SCSS tests"
  Rake::TestTask.new(:scss) do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_scss.rb']
    t.verbose = true
  end
  
  desc "Run site structure tests"
  Rake::TestTask.new(:structure) do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_site_structure.rb']
    t.verbose = true
  end
end

desc "Display information about available tests"
task :test_info do
  puts "Available test tasks:"
  puts "  rake test                 # Run all tests"
  puts "  rake test:config          # Run configuration tests"
  puts "  rake test:templates       # Run template tests"
  puts "  rake test:scss            # Run SCSS tests"
  puts "  rake test:structure       # Run site structure tests"
  puts ""
  puts "You can also run tests directly with:"
  puts "  ruby test/test_config.rb"
  puts "  ruby test/test_templates.rb"
  puts "  ruby test/test_scss.rb"
  puts "  ruby test/test_site_structure.rb"
end