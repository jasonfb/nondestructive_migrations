ENV['RAILS_ENV'] ||= 'test'

begin
  require 'byebug'
rescue LoadError
end

# start simplecov
require 'simplecov'
SimpleCov.start 'rails'

# require what the gem & tests need
require 'rails'
require 'minitest'
require 'minitest/autorun'
require 'minitest/rg'

# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
$:.unshift File.dirname(__FILE__)

# require the gem itself
require 'lib/nondestructive_migrations.rb'
Dir['lib/generators/*.rb'].sort.each { |f| require f }
Dir['lib/nondestructive_migrations/*.rb'].sort.each { |f| require f }
Dir['lib/*.rb'].sort.each { |f| require f }
