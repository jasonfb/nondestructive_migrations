require 'rails'
require 'active_record/migration'

require 'test_helper'
require 'minitest/autorun'

class DataMigrations::RailtieTest < Minitest::Test
  def test_that_the_migrate_task_can_run
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