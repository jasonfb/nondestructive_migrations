

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.libs << 'lib/generators'
  t.pattern = 'test/**/*_test.rb'
end

desc "Run tests"
task :default => :test

# require "rubygems"
# require "bundler/setup"

#
# require 'rake/testtask'
#
# Rake::TestTask.new do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = true
# end
#
# # desc "Run tests"
# task :default => :test
#
#
