require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'


module DataMigrations 
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    desc "Creates an initializer and copy files to your application."
    class_option :orm
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end
    
    def copy_initializer
      migration_template "create_data_migrations.rb", "db/migrate/create_data_migrations.rb"
    end
  end    
end

