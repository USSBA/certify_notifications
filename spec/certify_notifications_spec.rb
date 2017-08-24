require "spec_helper"

RSpec.describe CertifyNotifications do
  it "will have a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  it "will have an endpoint url" do
    expect(described_class.configuration.api_url).to eq('http://foo.bar/')
  end

  it "will specify the notification API version" do
    expect(described_class.configuration.notify_api_version).to eq(1)
  end

  it "will have a Notification class" do
    expect(described_class::Notification.new).to be
  end
end
