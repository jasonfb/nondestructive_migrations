


class NondestructiveMigrator < ActiveRecord::Migrator
  # This class related to data migration.
  # Used in rake tasks (rake data:[migrate|rollback|up|down])

  if defined?(ActiveRecord::MigrationContext)
    class SchemaMigration < ActiveRecord::SchemaMigration
      def self.table_name
        NondestructiveMigrator.schema_migrations_table_name
      end
    end

    class MigrationContext < ActiveRecord::MigrationContext
      def initialize(migrations_paths)
        super(migrations_paths)
        @schema_migration = NondestructiveMigrator::SchemaMigration
      end

      def new_migrator(*args)
        result = NondestructiveMigrator.new(*args)
        result.migration_context = self
        result
      end

      # these methods are copied from ActiveRecord::Migrator
      # replaced:
      #  1.) ActiveRecord::SchemaMigration with @schema_migration
      #  2.) ActiveRecord::Migrator.new with new_migrator

      def get_all_versions
        if @schema_migration.table_exists?
          @schema_migration.all_versions.map(&:to_i)
        else
          []
        end
      end

      def migrations_status
        db_list = @schema_migration.normalized_versions

        file_list = migration_files.map do |file|
          version, name, scope = parse_migration_filename(file)
          raise IllegalMigrationNameError.new(file) unless version
          version = @schema_migration.normalize_migration_number(version)
          status = db_list.delete(version) ? "up" : "down"
          [status, version, (name + scope).humanize]
        end.compact

        db_list.map! do |version|
          ["up", version, "********** NO FILE **********"]
        end

        (db_list + file_list).sort_by { |_, version, _| version }
      end

      def move(direction, steps)
        migrator = new_migrator(direction, migrations)

        if current_version != 0 && !migrator.current_migration
          raise UnknownMigrationVersionError.new(current_version)
        end

        start_index =
          if current_version == 0
            0
          else
            migrator.migrations.index(migrator.current_migration)
          end

        finish = migrator.migrations[start_index + steps]
        version = finish ? finish.version : 0
        send(direction, version)
      end

      def up(target_version = nil)
        selected_migrations = if block_given?
          migrations.select { |m| yield m }
        else
          migrations
        end

        new_migrator(:up, selected_migrations, target_version).migrate
      end

      def down(target_version = nil)
        selected_migrations = if block_given?
          migrations.select { |m| yield m }
        else
          migrations
        end

        new_migrator(:down, selected_migrations, target_version).migrate
      end
    end

    class << self
      def context(path)
        NondestructiveMigrator::MigrationContext.new(path)
      end

      def new_migrator(path, *args)
        result = self.new(*args)
        result.migration_context=context(path)
        result
      end

      def migrate(path)
        context(path).migrate()
      end

      def run(direction, path, target_version)
        new_migrator(path, direction, context(path).migrations, target_version).run
      end
    end

    def migration_context=(context)
      @migration_context = context
    end

    def load_migrated
      @migrated_versions = Set.new(@migration_context.get_all_versions)
    end
  end

  def record_version_state_after_migrating(version)
    if down?
      migrated.delete(version)
      ActiveRecord::DataMigration.where(:version => version.to_s).delete_all
    else
      migrated << version
      ActiveRecord::DataMigration.create!(:version => version.to_s)
    end
  end


  class <<self
    def migrations_path
      MIGRATIONS_PATH
    end
    
    def schema_migrations_table_name
      'data_migrations'
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


