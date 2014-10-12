
begin
  require 'byebug'
rescue LoadError
end


require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'


require 'rails'
require 'minitest'
require 'minitest/autorun'


MINITEST_BASE_CLASS = Minitest::Test

# if Rails.version =~ /4.1/
#   MINITEST_BASE_CLASS = Minitest::Test
# else
#   MINITEST_BASE_CLASS = MiniTest::Unit::TestCase
# end

# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

$:.unshift File.dirname(__FILE__)

require 'lib/nondestructive_migrations.rb'
Dir['lib/generators/*.rb'].sort.each { |f| require f }
Dir['lib/nondestructive_migrations/*.rb'].sort.each { |f| require f }
Dir['lib/*.rb'].sort.each { |f| require f }


