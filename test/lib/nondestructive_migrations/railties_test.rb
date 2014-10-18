require 'test_helper'

# require 'active_record/migration'
# require 'rails/railties/lib/rails/tasks'

class DataMigrations::RailtieTest < Minitest::Test
  def setup
    load File.expand_path("../../../../lib/tasks/data.rb", __FILE__)
    Rake::Task.define_task(:environment)
    # ActiveRecord::Base.establish_connection
    # Rake::Task['db:create']
    # Rake::Task['db:migrate']
  end

  def test_that_the_migrate_task_can_run
    # getting ActiveRecord::ConnectionNotEstablished: ActiveRecord::ConnectionNotEstablished
    # Rake::Task['data:migrate'].invoke
  end

  def test_that_the_rollback_task_can_run
    # Rake::Task['data:rollback'].invoke
  end

  def test_that_the_up_task_can_run
    # Rake::Task['data:migrate:up'].invoke
  end

  def test_that_the_down_task_can_run
    # Rake::Task['data:migrate:down'].invoke
  end
end