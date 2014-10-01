require 'spec_helper.rb'


describe "NondestructiveMigrator" do
  it "should be a class" do
    expect(NondestructiveMigrator).not_to be_nil
  end
  
  it "#schema_migrations_table_name" do
    expect(NondestructiveMigrator.schema_migrations_table_name).to eq('data_migrations')
  end
  
  it "#schema_migrations_table_name" do

    expect(NondestructiveMigrator.migrations_path).to eq(  'db/data_migrate')
  end

end