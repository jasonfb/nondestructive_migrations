# if ! Rails
# end


begin
  require 'byebug'
rescue LoadError
end


require 'simplecov'
SimpleCov.start 'rails'


$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'logger'


# require 'genspec'
# require 'mocha'


require 'rails'
require 'active_record'
require 'rails/generators'


require 'lib/nondestructive_migrations.rb'
Dir['lib/generators/*.rb'].sort.each { |f| require f }
Dir['lib/nondestructive_migrations/*.rb'].sort.each { |f| require f }
Dir['lib/*.rb'].sort.each { |f| require f }
# require File.expand_path('../lib/nondestructive_migrator.rb', __FILE__)
# I18n.enforce_available_locales = true


# require 'rspec/its'
# require 'barrier'
# require 'database_cleaner'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.raise_errors_for_deprecations!
end





