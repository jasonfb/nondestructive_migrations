module DataMigrations
  module BaseMigration
    require "net/http"
    require "uri"
    require "json"
    require "valid_email/validate_email"

    module ClassMethods
      def migration_information
        @migration_information ||= {}
        if block_given?
          yield
        else
          @migration_information
        end
      end

      def author_email(val)
        @migration_information[:author_email] = val
      end

      def author_slack_handle(val)
        @migration_information[:author_slack_handle] = val
      end

      def failure_consequences(val)
        @migration_information[:failure_consequences] = val
      end

      def failure_runbook(val)
        @migration_information[:failure_runbook] = val
      end

      def run_strategy(val)
        @migration_information[:run_strategy] = val
      end

      def migration_name(val)
        @migration_information[:migration_name] = val
      end
    end

    # If this module is included, have the parent class extend the above class methods
    # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
    def self.included(klass)
      klass.extend DataMigrations::BaseMigration::ClassMethods
    end

    def up
      define_queries
      fail "Data migration not running since data is not as expected" unless data_is_as_expected?
      fail "Authoring information not present, not running" unless authoring_information_present?
      print_starting_condition
      run_migration
      print_ending_condition

      if Rails.env.development?
        puts webhook_success_hash(nil)[:text]
      else
        send_slack_webhook(webhook_success_hash(nil))
        send_slack_webhook(webhook_success_hash(self.class.migration_information[:author_slack_handle]))
      end
    rescue => exception
      Bugsnag.notify(
        exception,
        authoring_information: {
          email_address: self.class.migration_information[:author_email],
          slack_handle: self.class.migration_information[:author_slack_handle],
          failure_consequences: self.class.migration_information[:failure_consequences],
          failure_runbook: self.class.migration_information[:failure_runbook],
          migration_name: self.class.migration_information[:migration_name],
        }
      )

      # Send the error to slack and ping user.
      if Rails.env.development?
        puts webhook_fail_hash(nil)[:text]
      else
        send_slack_webhook(webhook_fail_hash(exception, nil))
        send_slack_webhook(webhook_fail_hash(exception, self.class.migration_information[:author_slack_handle]))
      end

      # Make sure to still fail for real so that this data migration does not get recorded as run
      # and is attempted again once fixed.
      raise exception
    end

    def down
      reverse_migration
    end

    # Use this throughout your migration code to easily print to console your progress.
    def print_progress
      @progress_tracker ||= 0
      @progress_tracker += 1
      puts "Total progress: #{@progress_tracker}" if @progress_tracker % 500 == 0
    end

  private

    # We don't data migrations being created without authoring information.
    def authoring_information_present?
      self.class.migration_information[:author_email].present? and
        ValidateEmail.valid?(self.class.migration_information[:author_email]) and
        self.class.migration_information[:author_slack_handle].present? and
        self.class.migration_information[:author_slack_handle].starts_with?('@') and
        self.class.migration_information[:failure_consequences].present? and
        self.class.migration_information[:failure_runbook].present?
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
      rv = "*Successfully ran* migration #{self.class.migration_information[:migration_name]} in #{Rails.env}."

      # Wrap in defined? calls to make sure old data migrations do not fail on new lib code.
      if defined?(successful?) && defined?(success_message) && defined?(failure_message)
        if successful?
          rv += " The data migration end result is *successful*:"
          rv += "```#{success_message}```"
        else
          rv += " The data migration end result is *NOT SUCCESSFUL*:"
          rv += "```#{failure_message}```"
        end
      end

      rv
    end

    def webhook_fail_hash(exception, channel)
      {
        channel: channel || default_slack_channel,
        username: slack_username,
        icon_emoji: slack_emoji,
        text: webhook_fail_text(exception),
        link_names: 1
      }
    end

    def webhook_fail_text(exception)
      rv = "*Failed to run* (#{self.class.migration_information[:author_email]}) #{self.class.migration_information[:author_slack_handle]}'s migration #{self.class.migration_information[:migration_name]} in #{Rails.env}.\n"
      rv += "*Consequences*: #{self.class.migration_information[:failure_consequences]}.\n*Runbook*: #{self.class.migration_information[:failure_runbook]}.\n"
      rv += "```#{exception.message}\n#{exception.backtrace.first(10)}...```"
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
end
