module CertifyNotifications
  # configuration module
  class Configuration
    attr_accessor :api_url, :notify_api_version, :path_prefix, :notifications_path, :notification_preferences_path, :activity_log_path

    # main api endpoint
    def initialize
      @api_url = nil
      @notify_api_version = 1
      @path_prefix = "/notify"
      @notifications_path = "notifications"
      @notification_preferences_path = "notification_preferences"
      @activity_log_path = "activity_log"
    end
  end
end
