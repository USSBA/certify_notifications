require "spec_helper"
require 'support/v1/notifications_spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength
module V1
  RSpec.describe "V1 CertifyNotifications" do
    before do
      CertifyNotifications.configuration.notify_api_version = 1
    end

    describe 'Updating notifications' do
      context 'for editing notification read/unread status' do
        let(:read_notification) { NotificationSpecHelper.mock_notification_sym }
        let(:updated_notification_response) { CertifyNotifications::Notification.update(id: read_notification[:id], read: read_notification[:read]) }

        before do
          read_notification[:read] = true
          Excon.stub({}, body: read_notification.to_json, status: 201)
        end

        it "will return a notification" do
          expect(updated_notification_response[:body]['read']).to be(true)
        end
      end

      context "handles no parameters for updating notifications" do
        let(:notifications) { CertifyNotifications::Notification.update }

        it "will return an error notification when a bad parameter is sent" do
          expect(notifications[:body]).to eq(CertifyNotifications.bad_request[:body])
        end

        it "will return a 422 http status" do
          expect(notifications[:status]).to eq(CertifyNotifications.bad_request[:status])
        end
      end

      context "handles bad parameters for updating notifications" do
        let(:notifications) { CertifyNotifications::Notification.update(foo: 'bar') }

        it "will return an error notification when a bad parameter is sent" do
          expect(notifications[:body]).to eq(CertifyNotifications.unprocessable[:body])
        end

        it "will return a 422 http status" do
          expect(notifications[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        let(:bad_notification) { CertifyNotifications::Notification.update({read: true}) }
        let(:error_type) { "SocketError" }
        let(:error) { CertifyNotifications.service_unavailable error_type }

        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
          # reextend the endpoint to a dummy url
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "will return a 503" do
          expect(bad_notification[:status]).to eq(error[:status])
        end
        it "will return an error notification" do
          expect(bad_notification[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
