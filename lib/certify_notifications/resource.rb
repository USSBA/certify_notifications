require 'json'
require 'excon'

module CertifyNotifications
  # Controls the API connection
  class ApiConnection
    def initialize(url)
      @conn = Excon.new(url)
    end

    def request(options)
      add_version_to_header options
      @conn.request(options)
    end

    def add_version_to_header(options)
      version = CertifyNotifications.configuration.notify_api_version
      if options[:headers]
        options[:headers].merge!('Accept' => "application/sba.notify-api.v#{version}")
      else
        options.merge!(headers: { 'Accept' => "application/sba.notify-api.v#{version}" })
      end
    end
  end

  # base resource class
  # rubocop:disable Style/ClassVars
  class Resource
    @@connection = nil

    # excon connection
    def self.connection
      @@connection ||= ApiConnection.new api_url
    end

    def self.clear_connection
      @@connection = nil
    end

    def self.api_url
      CertifyNotifications.configuration.api_url
    end

    def self.path_prefix
      CertifyNotifications.configuration.path_prefix
    end

    def self.conversations_path
      CertifyNotifications.configuration.notifications_path
    end

    # json parse helper
    def self.json(response)
      JSON.parse(response)
    end

    # return params without ActionController default params
    def self.params_except_ac(params)
      params.except('controller', 'action')
    end

    def self.return_response(body, status)
      { body: body, status: status }
    end
  end
end
