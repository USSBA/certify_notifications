module CertifyNotifications
  # configuration module
  class Configuration
    attr_accessor :excon_timeout, :api_url, :notify_api_version, :path_prefix, :notifications_path, :notification_preferences_path

    # main api endpoint
    def initialize
      @excon_timeout = 5
      @api_url = nil
      @notify_api_version = 1
      @path_prefix = "/notify"
      @notifications_path = "notifications"
      @notification_preferences_path = "notification_preferences"
    end
  end
end
