require "spec_helper"

RSpec.describe CertifyNotifications do
  context "Creating the default Logger" do
    let(:logger) { CertifyNotifications::DefaultLogger.new.logger }

    it "uses the default debug log level when none is specified" do
      expect(logger.level).to eq(0)
    end
  end

  # handles all the standard log levels
  severity = CertifyNotifications::Resource.severity
  severity.each do |level|
    context "Creating the default Logger with '#{level}' log level specified" do
      let(:logger) { (CertifyNotifications::DefaultLogger.new level).logger }

      it "uses the default log level" do
        expect(logger.level).to eq(severity.index(level))
      end
    end
  end

  context "returns an error if an invalid log level is provided" do
    it "raises error" do
      expect { CertifyNotifications::DefaultLogger.new "foo" }.to raise_error(ArgumentError)
    end
  end
end
