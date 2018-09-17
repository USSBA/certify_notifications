module CertifyNotifications
  # configuration module
  class Configuration
    attr_accessor :excon_timeout, :api_key, :api_url, :notify_api_version, :path_prefix, :notifications_path, :notification_preferences_path, :logger, :log_level

    # main api endpoint
    def initialize
      @excon_timeout = 20
      @api_key = "fake_api_key" # TODO: set to nil once we start using API Gateways
      @api_url = "http://localhost:3004"
      @notify_api_version = 1
      @path_prefix = "/notify"
      @notifications_path = "notifications"
      @notification_preferences_path = "notification_preferences"
      @log_level = "debug"
      @logger = nil
    end
  end
end
