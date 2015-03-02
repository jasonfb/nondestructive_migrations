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

    def migrate(*args)
      if restore_table_name = ActiveRecord::Base.respond_to?(:schema_migrations_table_name=)
        orig_table = ActiveRecord::Base.schema_migrations_table_name
        ActiveRecord::Base.schema_migrations_table_name= schema_migrations_table_name
      else
        orig_table = nil
      end
      begin
        super
      ensure
        ActiveRecord::Base.schema_migrations_table_name = orig_table if restore_table_name
      end
    end
  end
end
