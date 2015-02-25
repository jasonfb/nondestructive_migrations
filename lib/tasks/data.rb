

namespace :data do
  task :data_migration_dependencies => :environment do
    require 'nondestructive_migrations'
  end

  desc "run data migration (#{MIGRATIONS_PATH})"
  task :migrate => :data_migration_dependencies do
    NondestructiveMigrator.migrate(MIGRATIONS_PATH)
  end

  desc "rollback data migration (#{MIGRATIONS_PATH})"
  task :rollback => :data_migration_dependencies do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    NondestructiveMigrator.rollback(MIGRATIONS_PATH,step)
  end

  desc "marks all as already run (#{MIGRATIONS_PATH})"
  task :mark_all_as_run => :data_migration_dependencies do
    exit(1) unless Rails.env.development? or Rails.env.test?
    puts "Marking all migrations found in #{MIGRATIONS_PATH} as run..."
    Dir.open(MIGRATIONS_PATH).each do |file_name|
      i = file_name.split('_').first.to_i
      next if i == 0
      ActiveRecord::Base.connection.execute("INSERT INTO data_migrations (version) VALUES(#{i})")
    end
  end

  namespace :migrate do
    desc %Q{runs the "up" for a given _data_ migration VERSION}
    task :up => :data_migration_dependencies do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      NondestructiveMigrator.run(:up, MIGRATIONS_PATH, version)
    end

    desc %Q{runs the "down" for a given _data_ migration VERSION}
    task :down => :data_migration_dependencies do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      NondestructiveMigrator.run(:down, MIGRATIONS_PATH, version)
    end
  end
end
