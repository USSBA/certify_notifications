require "spec_helper"
require 'support/v2/notifications_spec_helper'

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
module V2
  RSpec.describe "V2 CertifyNotifications" do
    before do
      CertifyNotifications.configuration.notify_api_version = 2
    end

    NotificationSpecHelper.mock_notification_types.each do |type, notify_mock|
      describe "create operations for #{type}" do
        context "for creating new notifications" do
          let(:mock) { NotificationSpecHelper.symbolize notify_mock }
          let(:notification) { CertifyNotifications::Notification.create_soft(mock) }
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
        context "for creating notifications with soft validation" do
          let(:first_notification) { NotificationSpecHelper.symbolize notify_mock }
          let(:second_notification) { NotificationSpecHelper.symbolize notify_mock }
          let(:invalid_notification) { NotificationSpecHelper.symbolize notify_mock }

          it "will create a set of valid notifications" do
            Excon.stub({}, status: 201)
            response = CertifyNotifications::Notification.create_soft([first_notification, second_notification])
            expect(response[:status]).to match(201)
          end
          it "will handle a set of invalid notifications" do
            Excon.stub({}, status: 207)
            response = CertifyNotifications::Notification.create_soft([first_notification, invalid_notification])
            expect(response[:status]).to match(207)
          end
        end
        context "for creating notifications with strict validation" do
          let(:first_notification) { NotificationSpecHelper.symbolize notify_mock }
          let(:second_notification) { NotificationSpecHelper.symbolize notify_mock }
          let(:invalid_notification) { NotificationSpecHelper.symbolize notify_mock }

          it "will create a set of valid notifications" do
            Excon.stub({}, status: 201)
            response = CertifyNotifications::Notification.create_strict([first_notification, second_notification])
            expect(response[:status]).to match(201)
          end
          it "will handle a set of invalid notifications" do
            Excon.stub({}, status: 400)
            response = CertifyNotifications::Notification.create_strict([first_notification, invalid_notification])
            expect(response[:status]).to match(400)
          end
        end
        context "with empty parameters" do
          let(:bad_notification) { CertifyNotifications::Notification.create_soft }

          it 'will return a status code of 400' do
            expect(bad_notification[:status]).to eq(CertifyNotifications.bad_request[:status])
          end

          it 'will return an error message' do
            expect(bad_notification[:body]).to eq(CertifyNotifications.bad_request[:body])
          end
        end

        context "with bad parameters" do
          let(:bad_notification) { CertifyNotifications::Notification.create_soft({foo: 'bar'}) }

          it 'will return a status code of 422' do
            expect(bad_notification[:status]).to eq(CertifyNotifications.unprocessable[:status])
          end

          it 'will return an error message' do
            expect(bad_notification[:body]).to eq(CertifyNotifications.unprocessable[:body])
          end
        end

        # this will work if the API is disconnected, but I can't figure out how to
        # fake the Excon connection to force it to fail in a test env.
        context "with api not found" do
          let(:notification) { CertifyNotifications::Notification.create_soft({uuid: NotificationSpecHelper.mock_notification_uuid}) }
          let(:error_type) { "SocketError" }
          let(:error) { CertifyNotifications.service_unavailable error_type }

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
            expect(notification[:body]).to match(/#{error_type}/)
          end
        end
      end
    end
  end
end
