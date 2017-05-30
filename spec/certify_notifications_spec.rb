require "spec_helper"

RSpec.describe CertifyNotifications do
  it "has a version number" do
    expect(CertifyNotifications::VERSION).not_to be nil
  end

  it "should have an endpoint url" do
    expect(CertifyNotifications.configuration.api_url).to eq('http://foo.bar/')
  end

  it "should specify the notification API version" do
    expect(CertifyNotifications.configuration.not_api_version).to eq(1)
  end

  it "should have a Notification class" do
    expect(CertifyNotifications::Notification.new).to be
  end

end
