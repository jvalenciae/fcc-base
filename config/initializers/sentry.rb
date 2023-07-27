# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN'] if ENV['SENTRY_DSN'].present?
  config.enabled_environments = %w[production staging]
  config.excluded_exceptions = Sentry::Configuration::IGNORE_DEFAULT - ['ActiveRecord::RecordNotFound']
  config.breadcrumbs_logger = [:active_support_logger]
  config.background_worker_threads = 0
  config.traces_sample_rate = 0.2 # set a float between 0.0 and 1.0 to enable performance monitoring
  config.traces_sampler = lambda do |sampling_context|
    # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
    next sampling_context[:parent_sampled] unless sampling_context[:parent_sampled].nil?

    # transaction_context is the transaction object in hash form
    # keep in mind that sampling happens right after the transaction is initialized
    # for example, at the beginning of the request
    transaction_context = sampling_context[:transaction_context]
    # transaction_context helps you sample transactions with more sophistication
    # for example, you can provide different sample rates based on the operation or name
    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    case op
    when /http/
      # for Rails applications, transaction_name would be the request's path (env["PATH_INFO"])
      # instead of "Controller#action"
      case transaction_name
      when /healthcheck/
        0.0
      else
        0.2
      end
    when /sidekiq/
      0.01 # you may want to set a lower rate for background jobs if the number is large
    else
      0.0 # ignore all other transactions
    end
  end
  config.release = 'git branch --show-current'
  config.capture_exception_frame_locals = true
end
# rubocop:enable Metrics/BlockLength
