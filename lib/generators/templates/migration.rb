class <%= migration_class_name %> < ActiveRecord::Migration
  # This ensures that the data migration does not run within a transaction
  # and therefore does not lock the database during long-running data migrations.
  disable_ddl_transaction!

  def up
    fail "Data migration not running since data is not as expected" unless data_is_as_expected?
    fail "Authoring information not present, not running" unless authoring_information_present?

    print_starting_condition

    # Write primary migration code here. Consider printing updates along the way, especially for large data migrations

    print_ending_condition
  rescue => exception
    Bugsnag.notify(
      exception,
      authoring_information: authoring_information
    )

    # Make sure to still fail for real so that this data migration does not get record as run
    # and is attempted again once fixed.
    raise exception
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

private

  # Often times certain things must be in place properly for the data migration to run, and you
  # may want to abort the data migration. Return false here if something is not as expected.
  # Exampel: ou are deleting duplicate data and only expect 2,000 duplicates after initial research,
  # but it turns out there are 100,000 when you run this, you may want to abort.
  def data_is_as_expected?
    # return false if relation_to_operate_on.count > 20
    # return false if DependentRecord.find_by(name: 'New Name').nil?
    true
  end

  # Allows the author of this data migration to add information for whomever ends up running or deploying it.
  # Name and email:
  #   Simply for deployer to quickly find comitter and fix issue.
  # Consequences on failure:
  #   Allows author to explain what could go wrong if this data migration fails.
  #   Example: 'All applications will be listed as not qualified on elasticsearch search results, even if they actualy are'.
  # Runbook on failure:
  #   Can be used for the author to explain what steps to take to fix the issue on potential failure scenarios.
  #   Example: 'Kick off an elasticsearch reindex of applications as soon as possible so that results are correct.'
  def authoring_information
    {
      email: 'nil@joinhandshake.com',
      consequences_on_failure: nil,
      runbook_on_failure: nil
    }
  end

  # We don't data migrations being created without authoring information.
  def authoring_information_present?
    authoring_information[:email] != 'nil@joinhandshake.com' and
      authoring_information[:consequences_on_failure].present? and
      authoring_information[:runbook_on_failure].present?
  end

  # Use this method to print out the starting condition of the data. This is often counts or aggregations
  # of counts. This can be useful for debugging.
  def print_starting_condition

  end

  # Use this method to print out the ending condition of the data after the migrations run. This is often
  # counts or aggregations of counts. This can be useful for debugging and ensuring everything ran as expected.
  def print_ending_condition

  end
end
