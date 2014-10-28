
MIGRATIONS_PATH = 'db/data_migrate'

require 'lib/generators/data_migration_install_generator.rb'
require 'lib/generators/data_migration_generator.rb'
require 'lib/nondestructive_migrator.rb'
# require 'tasks/data'

module NondestructiveMigrations
  require "lib/nondestructive_migrations/railtie.rb" if defined?(Rails)
end