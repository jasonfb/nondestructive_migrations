require 'nondestructive_migrations'
require 'rails'

module DataMigrations
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/data.rb'
    end
  end
end