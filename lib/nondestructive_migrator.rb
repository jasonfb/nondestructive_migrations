class NondestructiveMigrator < ActiveRecord::Migrator
  # This class related to data migration.
  # Used in rake tasks (rake data:[migrate|rollback|up|down])

  def record_version_state_after_migrating(version)
    if down?
      migrated.delete(version)
      ActiveRecord::DataMigration.where(version: version.to_s).delete_all
    else
      migrated << version
      ActiveRecord::DataMigration.create!(version: version.to_s)
    end
  end


  class <<self
    def migrations_path
      MIGRATIONS_PATH
    end

    def schema_migrations_table_name
      ActiveRecord::DataMigration.table_name
    end

    def get_all_versions(connection = ActiveRecord::Base.connection)
      if connection.table_exists?(schema_migrations_table_name)
        ActiveRecord::DataMigration.all.map { |x| x.version.to_i }.sort
      else
        []
      end
    end
  end
end
