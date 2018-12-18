require "spec_helper"
require 'support/v1/notifications_spec_helper'

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
module V1
  RSpec.describe "V1 CertifyNotifications::NotificationPreference.find" do
    before do
      CertifyNotifications.configuration.notify_api_version = 1
    end

    describe "get notification preferences operations" do
      context "for getting notification preferences" do
        let(:mock) { NotificationSpecHelper.mock_notification_preference }
        let(:notification_preferences) do
          Excon.stub({}, body: mock.to_json, status: 200)
          CertifyNotifications::NotificationPreference.find({user_id: mock[:user_id]})
        end

        it "returns a good status code" do
          expect(notification_preferences[:status]).to eq(200)
        end

        it "contains valid notification preferences attributes" do
          expect(notification_preferences[:body]['user_id']).to eq(mock[:user_id])
        end
      end

      context "handles errors" do
        context "no params" do
          let(:notification_preferences) { CertifyNotifications::NotificationPreference.find }

          it "returns an error message" do
            expect(notification_preferences[:body]).to eq(CertifyNotifications.bad_request[:body])
          end
          it "returns a 400" do
            expect(notification_preferences[:status]).to eq(CertifyNotifications.bad_request[:status])
          end
        end

        context "bad parameters" do
          let(:notification_preferences) { CertifyNotifications::NotificationPreference.find({foo: 'bar'}) }

          it "returns an error message when a bad parameter is sent" do
            expect(notification_preferences[:body]).to eq(CertifyNotifications.unprocessable[:body])
          end

          it "returns a 422 http status" do
            expect(notification_preferences[:status]).to eq(CertifyNotifications.unprocessable[:status])
          end
        end

        # this will work if the API is disconnected, but I can't figure out how to
        # fake the Excon connection to force it to fail in a test env.
        context "api not found" do
          let(:notification_preferences) do
            CertifyNotifications::Resource.clear_connection
            Excon.defaults[:mock] = false
            CertifyNotifications::NotificationPreference.find({id: 1})
          end
          let(:error_type) { "SocketError" }
          let(:error) { CertifyNotifications.service_unavailable error_type }

          after do
            CertifyNotifications::Resource.clear_connection
            Excon.defaults[:mock] = true
          end

          it "returns a 503" do
            expect(notification_preferences[:status]).to eq(error[:status])
          end

          it "returns an error message" do
            expect(notification_preferences[:body]).to match(/#{error_type}/)
          end
        end
      end
    end
  end
end
