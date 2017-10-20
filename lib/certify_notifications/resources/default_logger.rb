require 'Logger' unless defined?(Logger)

module CertifyNotifications
  # simple extension of the Ruby Logger that can accept the log severity level from user config
  class DefaultLogger < Resource
    attr_reader :logger

    # create the new logger with the default debug or accepting a log_level parameter
    def initialize(log_level = 'debug')
      @logger = Logger.new(STDOUT)
      @logger.level = parse_log_level log_level
    end

    private

    # convert log level text to integer, using Ruby Logger levels in order of severity
    # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
    def parse_log_level(log_level)
      if log_level.is_a?(Integer)
        return log_level
      else
        case log_level.to_s.downcase
        when 'debug'
          return 0
        when 'info'
          return 1
        when 'warn'
          return 2
        when 'error'
          return 3
        when 'fatal'
          return 4
        when 'unknown'
          return 5
        else
          raise ArgumentError, "invalid log level: #{log_level}"
        end
      end
    end
  end
end
