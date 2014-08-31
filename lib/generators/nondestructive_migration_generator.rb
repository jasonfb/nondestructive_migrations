require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'


module DataMigrations 
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    desc "Creates a Devise initializer and copy locale files to your application."
    class_option :orm
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end
    
    def copy_initializer
      migration_template "create_data_migrations.rb", "db/migrate/create_data_migrations.rb"
    end
  end    
end


class DataMigrationGenerator < ActiveRecord::Generators::Base
  self.source_root(File.join(self.superclass.base_root,'active_record/migration/templates'))

  desc <<-DESC
Description:
    Creates new nondestructive migration
DESC

  def create_data_migration_file
    migration_template "migration.rb", "db/data_migrate/#{file_name}.rb"
  end

  # 'migration.rb' now requires this var/method
  def migration_action
    'create'
  end

  private

  # this used in migration template which is inherited, we want this values to be an empty array.
  def attributes
    []
  end
end

