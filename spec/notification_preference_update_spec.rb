require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength, Layout/IndentHash
RSpec.describe "CertifyNotifications::NotificationPreference.update" do
  describe 'Updating notification preferences' do
    context 'for editing notification preferences' do
      before do
        pref = NotificationSpecHelper.mock_notification_preference
        pref[:subscribe_low_priority_email] = false
        Excon.stub({}, body: pref.to_json, status: 201)
        @updated_preference_response = CertifyNotifications::NotificationPreference.update({
          user_id: pref[:user_id],
          subscribe_low_priority_email: pref[:subscribe_low_priority_email]
        })
      end

      it "should return a notification" do
        expect(@updated_preference_response[:body]['subscribe_low_priority_email']).to be(false)
      end
    end

    context "handles no parameters for updating notifications" do
      before do
        @preferences = CertifyNotifications::NotificationPreference.update
      end

      it "should return an error notification when a bad parameter is sent" do
        expect(@preferences[:body]).to eq(CertifyNotifications.bad_request[:body])
      end

      it "should return a 422 http status" do
        expect(@preferences[:status]).to eq(CertifyNotifications.bad_request[:status])
      end
    end

    context "handles bad parameters for updating notifications" do
      before do
        @preferences = CertifyNotifications::NotificationPreference.update(foo: 'bar')
      end

      it "should return an error notification when a bad parameter is sent" do
        expect(@preferences[:body]).to eq(CertifyNotifications.unprocessable[:body])
      end

      it "should return a 422 http status" do
        expect(@preferences[:status]).to eq(CertifyNotifications.unprocessable[:status])
      end
    end

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      before do
        CertifyNotifications::Resource.clear_connection
        Excon.defaults[:mock] = false
        # reextend the endpoint to a dummy url
        @bad_preference = CertifyNotifications::NotificationPreference.update({user_id: 99, subscribe_low_priority_email: true})
        @error = CertifyNotifications.service_unavailable 'Excon::Error::Socket'
      end

      after do
        CertifyNotifications::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "should return a 503" do
        expect(@bad_preference[:status]).to eq(@error[:status])
      end

      it "should return an error notification" do
        expect(@bad_preference[:body]).to eq(@error[:body])
      end
    end
  end
end
