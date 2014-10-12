
begin
  require 'byebug'
rescue LoadError
end

require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

$:.unshift File.dirname(__FILE__)

require 'lib/nondestructive_migrations.rb'
Dir['lib/generators/*.rb'].sort.each { |f| require f }
Dir['lib/nondestructive_migrations/*.rb'].sort.each { |f| require f }
Dir['lib/*.rb'].sort.each { |f| require f }
