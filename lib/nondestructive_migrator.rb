class NondestructiveMigrator < ActiveRecord::Migrator
  # This class related to data migration.
  # Used in rake tasks (rake data:[migrate|rollback|up|down])
  class <<self
    def migrations_path
      MIGRATIONS_PATH
    end

    def schema_migrations_table_name
      'data_migrations'
    end
  end
end
