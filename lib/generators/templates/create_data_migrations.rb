class CreateDataMigrations < ActiveRecord::Migration
  def self.up
    create_table ActiveRecord::DataMigration do |t|
      t.string :version
    end
  end

  def self.down
    drop_table ActiveRecord::DataMigration
  end
end
