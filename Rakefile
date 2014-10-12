require 'rake/testtask'


# if Rails.version =~ /4.1/
  require "minitest"
  require 'minitest/autorun'
# end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.libs << 'lib/generators'
  t.pattern = 'test/**/*_test.rb'
end

desc "Run tests"
task :default => :test


task :console do
  require 'irb'
  require 'irb/completion'
  require 'my_gem' # You know what to do.
  ARGV.clear
  IRB.start
end


