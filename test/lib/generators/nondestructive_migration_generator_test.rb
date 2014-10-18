require 'test_helper'

# This is the class that will create the SCHEMA migration
# to create the table data_migrations

class InstallGeneratorTest < Rails::Generators::TestCase
  tests DataMigrations::InstallGenerator
  destination File.expand_path("../../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  # teardown :destroy_files

  # DO NOT USE exec with testunit
  # def destroy_files
  #   # puts "cleaning up generated files ..."
  #   exec "rm -rf test/tmp/"
  # end

  def test_migration
    # assert false
    migration = "hello_world_migration"
    run_generator [migration]
    assert_migration "db/migrate/create_data_migrations.rb"
    assert_migration "db/migrate/create_data_migrations.rb", /class CreateDataMigrations < ActiveRecord::Migration/
    assert_migration "db/migrate/create_data_migrations.rb", /create_table :data_migrations do |t|/
    assert_migration "db/migrate/create_data_migrations.rb", /drop_table :data_migrations/
    # destroy_files
  end
end