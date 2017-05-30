module CertifyNotifications
  # configuration module
  class Configuration
    attr_accessor :api_url, :not_api_version, :path_prefix, :not_path

    # main api endpoint
    def initialize
      @api_url = nil
      @not_api_version = 1
      @path_prefix = "/not"
      @notifications_path = "notifications"
    end
  end
end
