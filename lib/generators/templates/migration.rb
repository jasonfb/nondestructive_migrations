class <%= migration_class_name %> < DataMigrations::BaseMigration
  # Allows the author of this data migration to add information for whomever ends up running or deploying it.
  # Name and email:
  #   Simply for deployer to quickly find comitter and fix issue.
  # Consequences on failure:
  #   Allows author to explain what could go wrong if this data migration fails.
  #   Example: 'All applications will be listed as not qualified on elasticsearch search results, even if they actualy are'.
  # Runbook on failure:
  #   Can be used for the author to explain what steps to take to fix the issue on potential failure scenarios.
  #   Example: 'Kick off an elasticsearch reindex of applications as soon as possible so that results are correct.'
  AUTHOR_EMAIL = nil
  AUTHOR_SLACK_HANDLE = nil
  FAILURE_CONSEQUENCES = nil
  FAILURE_RUNBOOK = nil

  # Define common queries that you will be using for printing start information, running the migration itself
  # and printing the ending condition in DRY global variables.
  def define_queries
  end

  # Often times certain things must be in place properly for the data migration to run, and you
  # may want to abort the data migration. Return false here if something is not as expected.
  # Exampel: ou are deleting duplicate data and only expect 2,000 duplicates after initial research,
  # but it turns out there are 100,000 when you run this, you may want to abort.
  def data_is_as_expected?
    # return false if @relation_to_operate_on.count > 20
    # return false if DependentRecord.find_by(name: 'New Name').nil?
    true
  end

  # Use this method to print out the starting condition of the data. This is often counts or aggregations
  # of counts. This can be useful for debugging.
  def print_starting_condition
  end

  # Write primary migration code here. Consider printing updates along the way, especially for large data migrations
  def run_migration
  end

  # Use this method to print out the ending condition of the data after the migrations run. This is often
  # counts or aggregations of counts. This can be useful for debugging and ensuring everything ran as expected.
  def print_ending_condition
  end

  # Define if interested in running, or leave commented out if not needed
  def reverse_migration
    raise ActiveRecord::IrreversibleMigration
  end
end
