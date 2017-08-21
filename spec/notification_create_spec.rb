require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe CertifyNotifications do
  NotificationSpecHelper.mock_notification_types.each do |type, notify_mock|
    describe "create operations for #{type}" do
      context "for creating new notifications" do
        let(:mock) { NotificationSpecHelper.symbolize notify_mock }
        let(:notification) { CertifyNotifications::Notification.create(mock) }
        let(:body) { notification[:body] }

        before do
          Excon.stub({}, body: mock.to_json, status: 201)
        end

        it "will return the correct post response" do
          expect(notification[:status]).to eq(201)
        end
        it "will return the correct notification object" do
          expect(body["id"]).to eq(mock[:id])
        end
        it "will handle being given a string" do
          expect(body["recipient_id"]).to eq(mock[:recipient_id])
        end
      end
      context "with empty parameters" do
        let(:bad_notification) { CertifyNotifications::Notification.create }

        it 'will return a status code of 400' do
          expect(bad_notification[:status]).to eq(described_class.bad_request[:status])
        end

        it 'will return an error message' do
          expect(bad_notification[:body]).to eq(described_class.bad_request[:body])
        end
      end

      context "with bad parameters" do
        let(:bad_notification) { CertifyNotifications::Notification.create({foo: 'bar'}) }

        it 'will return a status code of 422' do
          expect(bad_notification[:status]).to eq(described_class.unprocessable[:status])
        end

        it 'will return an error message' do
          expect(bad_notification[:body]).to eq(described_class.unprocessable[:body])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "with api not found" do
        let(:notification) { CertifyNotifications::Notification.create({id: 1}) }
        let(:error) { described_class.service_unavailable 'Excon::Error::Socket' }

        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end
        it "will return a 503" do
          expect(notification[:status]).to eq(error[:status])
        end

        it "will return an error message" do
          expect(notification[:body]).to eq(error[:body])
        end
      end
    end
  end
end
