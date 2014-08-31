class NondestructiveMigrator < ActiveRecord::Migrator
  # This class related to data migration.
  # Used in rake tasks (rake candi:data:[migrate|rollback|up|down])
  class <<self
    def migration_path
      # came from lib/tasks/data_migrations.rake
      MIGRATIONS_PATH
    end

    def schema_migrations_table_name
      'data_migrations'
    end
  end
end
