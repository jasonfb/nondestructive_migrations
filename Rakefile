
require "rubygems"
require "bundler/setup"

require 'rake/testtask'

require "minitest"
require 'minitest/autorun'


Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.libs << 'lib/generators'
  t.libs << 'lib/tasks'
  t.libs << 'lib/nondestructive_migrations'
  t.pattern = 'test/**/*_test.rb'
end

desc "Run tests"
task :default => :test


task :console do
  require 'irb'
  require 'irb/completion'
  require 'nondestructive_migrations' # You know what to do.
  ARGV.clear
  IRB.start
end


