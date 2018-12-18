require 'json'
require 'excon'

module CertifyNotifications
  # Controls the API connection
  class ApiConnection
    attr_accessor :conn
    def initialize(url, timeout, api_key = nil)
      params = {
        connect_timeout: timeout,
        read_timeout: timeout,
        write_timeout: timeout
      }
      params[:headers] = { 'x-api-key' => api_key } unless api_key.nil?
      @conn = Excon.new(url, params)
    end

    def request(options)
      add_version_to_header options
      @conn.request(options)
    end

    def add_version_to_header(options)
      version = CertifyNotifications.configuration.notify_api_version
      if options[:headers]
        options[:headers].merge!('Accept' => "application/sba.not-api.v#{version}")
      else
        options.merge!(headers: { 'Accept' => "application/sba.not-api.v#{version}" })
      end
    end
  end

  # base resource class
  # rubocop:disable Style/ClassVars
  class Resource
    @@connection = nil

    # excon connection
    def self.connection
      @@connection ||= ApiConnection.new api_url, excon_timeout, api_key
    end

    def self.clear_connection
      @@connection = nil
    end

    def self.excon_timeout
      CertifyNotifications.configuration.excon_timeout
    end

    def self.api_key
      CertifyNotifications.configuration.api_key
    end

    def self.api_url
      CertifyNotifications.configuration.api_url
    end

    def self.notify_api_version
      CertifyNotifications.configuration.notify_api_version
    end

    def self.path_prefix
      CertifyNotifications.configuration.path_prefix
    end

    def self.notifications_path
      CertifyNotifications.configuration.notifications_path
    end

    def self.notification_preferences_path
      CertifyNotifications.configuration.notification_preferences_path
    end

    def self.logger
      CertifyNotifications.configuration.logger ||= (DefaultLogger.new log_level).logger
    end

    def self.log_level
      CertifyNotifications.configuration.log_level
    end

    def self.handle_excon_error(error)
      logger.error [error.message, error.backtrace.join("\n")].join("\n")
      CertifyNotifications.service_unavailable error.message
    end

    # json parse helper
    def self.json(response)
      JSON.parse(response)
    end

    # empty params
    def self.empty_params(params)
      params.nil? || params.empty?
    end

    def self.return_response(body, status)
      { body: body, status: status }
    end

    def self.symbolize_params(p)
      # rebuild params as symbols, dropping ones as strings
      symbolized_params = {}
      p.each do |key, value|
        if key.is_a? String
          symbolized_params[key.to_sym] = value
        else
          symbolized_params[key] = value
        end
      end
      symbolized_params
    end
  end
end
