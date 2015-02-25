class <%= migration_class_name %> < ActiveRecord::Migration
  # This ensures that the data migration does not run within a disable_ddl_transaction
  # and therefore does not lock the database during long-running data migrations.
  disable_ddl_transaction!

  def up

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
