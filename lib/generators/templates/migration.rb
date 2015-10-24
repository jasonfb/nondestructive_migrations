class <%= migration_class_name %> < ActiveRecord::Migration
  require "net/http"
  require "uri"
  require "json"

  # This ensures that the data migration does not run within a transaction
  # and therefore does not lock the database during long-running data migrations.
  disable_ddl_transaction!

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

  ##########################################################
  # DO NOT EDIT BELOW THIS LINE
  # This can stay as is and only the above functions and variables need to be changed.
  ##########################################################
  def up
    define_queries
    fail "Data migration not running since data is not as expected" unless data_is_as_expected?
    fail "Authoring information not present, not running" unless authoring_information_present?
    print_starting_condition
    run_migration
    print_ending_condition

    unless Rails.env.development?
      send_slack_webhook(webhook_success_hash(nil))
      send_slack_webhook(webhook_success_hash(AUTHOR_SLACK_HANDLE))
    end
  rescue => exception
    Bugsnag.notify(
      exception,
      authoring_information: {
        email_address: AUTHOR_EMAIL,
        slack_handle: AUTHOR_SLACK_HANDLE,
        failure_consequences: FAILURE_CONSEQUENCES,
        failure_runbook: FAILURE_RUNBOOK,
      }
    )

    # Send the error to slack and ping user.
    unless Rails.env.development?
      send_slack_webhook(webhook_fail_hash(exception, nil))
      send_slack_webhook(webhook_fail_hash(exception, AUTHOR_SLACK_HANDLE))
    end

    # Make sure to still fail for real so that this data migration does not get record as run
    # and is attempted again once fixed.
    raise exception
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

private

  # We don't data migrations being created without authoring information.
  def authoring_information_present?
    AUTHOR_EMAIL.present? and
      ValidateEmail.valid?(AUTHOR_EMAIL) and
      AUTHOR_SLACK_HANDLE.present? and
      AUTHOR_SLACK_HANDLE.starts_with?('@') and
      FAILURE_CONSEQUENCES.present? and
      FAILURE_RUNBOOK.present?
  end

  ### Slack Messaging ###
  def send_slack_webhook(payload)
    return unless ENV['DATA_MIGRATIONS_SLACK_WEBHOOK'].present?

    uri = URI.parse(ENV['DATA_MIGRATIONS_SLACK_WEBHOOK'])
    parms_form = { payload: payload.to_json }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(parms_form)

    http.request(request)
  end

  def webhook_success_hash(channel)
    {
      channel: channel || default_slack_channel,
      username: slack_username,
      icon_emoji: slack_emoji,
      text: webhook_success_text
    }
  end

  def webhook_success_text
    "*Successfully ran* migration #{self.class.name} in #{Rails.env}."
  end

  def webhook_fail_hash(exception, channel)
    {
      channel: channel || default_slack_channel,
      username: slack_username,
      icon_emoji: slack_emoji,
      text: webhook_fail_text(exception)
    }
  end

  def webhook_fail_text(exception)
    rv = "*Failed to run* (#{AUTHOR_EMAIL}) #{AUTHOR_SLACK_HANDLE}'s migration #{self.class.name} in #{Rails.env}.\n"
    rv += "*Consequences*: #{FAILURE_CONSEQUENCES}.\n*Runbook*: #{FAILURE_RUNBOOK}.\n"
    rv += "```#{exception.message}\n#{exception.backtrace.first(4)}...```"
    rv
  end

  def default_slack_channel
    '#deployments'
  end

  def slack_username
    'handshake-data-migrations-bot'
  end

  def slack_emoji
    ':handshake:'
  end
end
