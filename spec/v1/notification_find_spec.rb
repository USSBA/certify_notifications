require "spec_helper"
require 'support/v1/notifications_spec_helper'

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
module V1
  RSpec.describe "V1 CertifyNotifications" do
    before do
      CertifyNotifications.configuration.notify_api_version = 1
    end

    describe "get notifications operations" do
      context "for getting notifications" do
        let(:mock) { NotificationSpecHelper.mock_notifications_sym }
        let(:notifications) { CertifyNotifications::Notification.find({recipient_id: 1}) }
        let(:body) { notifications[:body] }

        before do
          Excon.stub({}, body: mock.to_json, status: 200)
        end

        it "will return a good status code" do
          expect(notifications[:status]).to eq(200)
        end

        it "will return an array of notifications" do
          expect(body.length).to be > 0
        end

        it "will contain valid notifications attributes" do
          expect(body[0][:id]).to eq(mock[0]["id"])
        end
      end

      context "with no params" do
        let(:notifications) { CertifyNotifications::Notification.find }
        let(:body) { notifications[:body] }

        it "will return an error message" do
          expect(body).to eq(CertifyNotifications.bad_request[:body])
        end
        it "will return a 400" do
          expect(notifications[:status]).to eq(CertifyNotifications.bad_request[:status])
        end
      end

      context "with bad parameters" do
        let(:notifications) { CertifyNotifications::Notification.find({foo: 'bar'}) }
        let(:body) { notifications[:body] }

        it "will return an error message when a bad parameter is sent" do
          expect(body).to eq(CertifyNotifications.unprocessable[:body])
        end

        it "will return a 422 http status" do
          expect(notifications[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "with api not found" do
        let(:notifications) { CertifyNotifications::Notification.find({id: 1}) }
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
          expect(notifications[:status]).to eq(error[:status])
        end

        it "will return an error message" do
          expect(notifications[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
