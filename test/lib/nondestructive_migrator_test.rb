require 'test_helper'

# require 'rails'
# require 'active_record/migration'

class NondestructiveMigratorTest < Minitest::Test
  def test_nondestructive_migrator
    assert NondestructiveMigrator
  end

  def test_schema_migrations_table_name
    assert_equal NondestructiveMigrator.schema_migrations_table_name, 'data_migrations'
  end

  def test_migrations_path
    assert_equal NondestructiveMigrator.migrations_path, 'db/data_migrate'
  end
end