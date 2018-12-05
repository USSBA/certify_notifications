require 'spec_helper'
require 'support/v2/notifications_spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength, Layout/IndentHash
module V2
  RSpec.describe "CertifyNotifications::NotificationPreference.update" do
    before do
      CertifyNotifications.configuration.notify_api_version = 2
    end

    describe 'Updating notification preferences' do
      context 'for editing notification preferences' do
        before do
        end

        let(:updated_preference_response) do
          pref = NotificationSpecHelper.mock_notification_preference
          pref[:subscribe_low_priority_email] = false
          Excon.stub({}, body: pref.to_json, status: 201)
          CertifyNotifications::NotificationPreference.update({
            user_uuid: pref[:user_id],
            subscribe_low_priority_email: pref[:subscribe_low_priority_email]
          })
        end

        it "returns a notification" do
          expect(updated_preference_response[:body]['subscribe_low_priority_email']).to be(false)
        end
      end

      context "handles no parameters for updating notifications" do
        let(:preferences) { CertifyNotifications::NotificationPreference.update }

        it "returns an error notification when a bad parameter is sent" do
          expect(preferences[:body]).to eq(CertifyNotifications.bad_request[:body])
        end

        it "returns a 422 http status" do
          expect(preferences[:status]).to eq(CertifyNotifications.bad_request[:status])
        end
      end

      context "handles bad parameters for updating notifications" do
        let(:preferences) { CertifyNotifications::NotificationPreference.update(foo: 'bar') }

        it "returns an error notification when a bad parameter is sent" do
          expect(preferences[:body]).to eq(CertifyNotifications.unprocessable[:body])
        end

        it "returns a 422 http status" do
          expect(preferences[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
        end

        let(:bad_preference) { CertifyNotifications::NotificationPreference.update({user_uuid: NotificationSpecHelper.mock_user_uuid, subscribe_low_priority_email: true}) }
        let(:error_type) { "SocketError" }
        let(:error) { CertifyNotifications.service_unavailable error_type }

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "returns a 503" do
          expect(bad_preference[:status]).to eq(error[:status])
        end

        it "returns an error notification" do
          expect(bad_preference[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
