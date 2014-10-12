
MIGRATIONS_PATH = 'db/data_migrate'

require 'generators/nondestructive_migration_generator.rb'
require 'generators/data_migration_generator.rb'
require 'nondestructive_migrator.rb'

module NondestructiveMigrations
  require "nondestructive_migrations/railtie.rb" if defined?(Rails)
end