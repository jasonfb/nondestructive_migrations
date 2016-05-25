# this is the generator used to create a data migration
class DataMigrationGenerator < ActiveRecord::Generators::Base
   self.source_root(File.expand_path("../templates", __FILE__))

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

