require "spec_helper"

RSpec.describe "CertifyNotifications" do
  it "will have a version number" do
    expect(CertifyNotifications::VERSION).not_to be nil
  end

  it "will have an endpoint url" do
    expect(CertifyNotifications.configuration.api_url).to eq('http://foo.bar/')
  end

  it "will specify the notification API version" do
    expect(CertifyNotifications.configuration.notify_api_version).to eq(1)
  end

  it "will have a Notification class" do
    expect(CertifyNotifications::Notification.new).to be
  end
end
