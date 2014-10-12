


require 'spec_helper'
# require "generator_spec"
# require "generators/nondestructive_migration_generator"


describe DataMigrations::InstallGenerator do
  it "should be able to create a data migration if mocked" do
    # file = mock('file')

    # File.should_receive(:open).and_yield(file)
    # file.should_receive(:write).with("text")
    # exec "rails generate data_migration HelloWorldDataMigration"

      # assert_file "db/data_migrate/20141011234754_hello_world_data_migration.rb"
  end
  # with_args :users do
  #   it "should generate a UsersController" do
  #     subject.should generate("app/controllers/users_controller.rb") { |content|
  #       content.should =~ /class UserController/
  #     }
  #   end

    it "should generate a readme file" do
      subject.should generate("README")
    end

    it "should generate successfully" do
      subject.should generate
    end
end

# class AppGeneratorTest < Rails::Generators::TestCase
#   tests AppGenerator
#   destination File.expand_path("../tmp", File.dirname(__FILE__))
#   setup :prepare_destination
# end
#

# describe DataMigrations::InstallGenerator do
#   destination File.expand_path("../../tmp", __FILE__)
#   arguments %w(something)
#
#   before(:all) do
#     prepare_destination
#     run_generator
#   end
#
#   it "creates a test initializer" do
#     assert_file "config/initializers/test.rb", "# Initializer"
#   end
# end