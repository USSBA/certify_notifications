module CertifyNotifications
  # configuration module
  class Configuration
    attr_accessor :api_url, :notify_api_version, :path_prefix, :notify_path

    # main api endpoint
    def initialize
      @api_url = nil
      @notify_api_version = 1
      @path_prefix = "/notify"
      @notifications_path = "notifications"
    end
  end
end
