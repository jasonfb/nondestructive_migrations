class <%= migration_class_name %> < ActiveRecord::Migration
  include DataMigrations::BaseMigration

  # This ensures that the data migration does not run within a transaction
  # and therefore does not lock the database during long-running data migrations.
  disable_ddl_transaction!

  migration_information do
    author_email "<%= ENV['MIGRATION_EMAIL'] %>"
    author_slack_handle "<%= ENV['MIGRATION_SLACK_HANDLE'] %>" # Don't forget the '@' in front
    failure_consequences nil # Allows author to explain what could go wrong if this data migration fails.
    failure_runbook nil # Can be used for the author to explain what steps to take to fix the issue on potential failure scenarios.
    migration_name "<%= migration_class_name %>"
  end

  # Define common queries that you will be using for printing start information, running the migration itself
  # and printing the ending condition in DRY global variables.
  def define_queries; end

  # Often times certain things must be in place properly for the data migration to run, and you
  # may want to abort the data migration. Return false here if something is not as expected.
  # Example: You are deleting duplicate data and only expect 2,000 duplicates after initial research,
  # but it turns out there are 100,000 when you run this, you may want to abort.
  def data_is_as_expected?
    # return false if DependentRecord.find_by(name: 'New Name').nil?

    case Rails.env.to_sym
    when :development
      true
    when :staging
      true
    when :demo
      true
    when :production
      # return false if relation_to_operate_on.count > 20_000
      true
    else
      raise "Encountered unknown rails env of #{Rails.env} in data migration."
    end
  end

  # Use this method to print out the starting condition of the data. This is often counts or aggregations
  # of counts. This can be useful for debugging.
  def print_starting_condition; end

  # Write primary migration code here. Consider printing updates along the way, especially for large data migrations
  def run_migration; end

  # Use this method to print out the ending condition of the data after the migrations run. This is often
  # counts or aggregations of counts. This can be useful for debugging and ensuring everything ran as expected.
  def print_ending_condition; end

  # Allows you to consider the data migration successful or not. Data migration will
  # still be considered finished and will not run again.
  def successful?
    true
  end

  # Sent to slack if errored. Likely, this is a simple string and the real logic is in
  # the 'successful?' method. It is useful to put counts here.
  def failure_message; end

  # Sent to slack if succcessful. Likely, this is a simple string and the real logic is in
  # the 'successful?' method. It is useful to put counts here.
  def success_message; end

  # Define if interested in running, or leave commented out if not needed
  def reverse_migration
    raise ActiveRecord::IrreversibleMigration
  end
end
