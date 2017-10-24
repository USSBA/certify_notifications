require "byebug"
require "certify_notifications/configuration"
require "certify_notifications/error"
require "certify_notifications/resource"
require "certify_notifications/version"
require "certify_notifications/resources/default_logger"
require "certify_notifications/resources/notification"
require "certify_notifications/resources/notification_preference"

# the base CertifyNotifications module that wraps all notifications calls
module CertifyNotifications
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
