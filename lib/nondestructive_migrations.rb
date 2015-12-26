MIGRATIONS_PATH = 'db/data_migrate'

require 'generators/data_migration_install_generator.rb'
require 'generators/data_migration_generator.rb'
require 'nondestructive_migrator.rb'
require 'nondestructive_migrations/nondestructive_migration.rb'

module NondestructiveMigrations
  require "nondestructive_migrations/railtie.rb" if defined?(Rails)
end
