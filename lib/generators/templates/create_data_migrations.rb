class CreateDataMigrations < ActiveRecord::Migration
  def self.up
    create_table :data_migrations do |t|
      t.string :version
    end
  end

  def self.down
    drop_table :data_migrations
  end
end
