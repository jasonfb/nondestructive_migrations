require 'test_helper'

# require 'active_record/migration'
# require 'rails/railties/lib/rails/tasks'

require 'tasks/data.rb'
class DataMigrations::RailtieTest < Minitest::Test
  def setup

    FileUtils::mkdir_p './config/db/data_migrate'
    dummy_migration_file = File.open( "config/db/data_migrate/20140101125959_xyz.rb","w" )
    dummy_migration_file <<  <<-eos
    class Xyz < ActiveRecord::Migration
      def up
      end

      def down
      end
    end
eos
    dummy_migration_file.close

    Rake::Task.define_task(:environment)
    ActiveRecord::Base.establish_connection
  end

  # teardown :destroy_files

  def teardown
    FileUtils.rm_rf("config/db/data_migrate/")
  end

  def test_that_the_migrate_task_can_run
    NondestructiveMigrator.expects(:migrate).with(MIGRATIONS_PATH)
    Rake::Task['data:migrate'].execute
  end

  def test_that_the_rollback_task_can_run
    NondestructiveMigrator.expects(:rollback).with(MIGRATIONS_PATH, 1)
    assert Rake::Task['data:rollback'].invoke
  end

  # TODO: fix these
  # getting error with folder not existing
  # def test_that_the_mark_all_as_run_task_can_run
  #   assert Rake::Task['data:mark_all_as_run'].invoke
  # end


  # TODO: Fix these
  # getting No migration with version number 20140101125959
  # def test_that_the_up_task_can_run
  #   NondestructiveMigrator.expects(:up).with(MIGRATIONS_PATH)
  #   ENV['VERSION'] = "20140101125959"
  #   Rake::Task['data:migrate:up'].invoke
  # end

  # def test_that_the_down_task_can_run
  #   NondestructiveMigrator.expects(:down).with(MIGRATIONS_PATH)
  #   ENV['VERSION'] = "00000000000000"
  #   Rake::Task['data:migrate:down'].invoke("VERSION=00000000000000")
  # end
end
