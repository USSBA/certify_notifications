require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe "CertifyNotifications::NotificationPreference.find" do
  describe "get notification preferences operations" do
    context "for getting notification preferences" do
      before do
        @mock = NotificationSpecHelper.mock_notification_preference
        Excon.stub({}, body: @mock.to_json, status: 200)
        @notification_preferences = CertifyNotifications::NotificationPreference.find({user_id: @mock[:user_id]})
        @body = @notification_preferences[:body]
      end

      it "should return a good status code" do
        expect(@notification_preferences[:status]).to eq(200)
      end

      it "should contain valid notification preferences attributes" do
        expect(@notification_preferences[:body]['user_id']).to eq(@mock[:user_id])
      end
    end

    context "handles errors" do
      context "no params" do
        before do
          @notification_preferences = CertifyNotifications::NotificationPreference.find
          @body = @notification_preferences[:body]
        end
        it "should return an error message" do
          expect(@body).to eq(CertifyNotifications.bad_request[:body])
        end
        it "should return a 400" do
          expect(@notification_preferences[:status]).to eq(CertifyNotifications.bad_request[:status])
        end
      end

      context "bad parameters" do
        before do
          @notification_preferences = CertifyNotifications::NotificationPreference.find({foo: 'bar'})
        end

        it "should return an error message when a bad parameter is sent" do
          expect(@notification_preferences[:body]).to eq(CertifyNotifications.unprocessable[:body])
        end

        it "should return a 422 http status" do
          expect(@notification_preferences[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
          # reextend the endpoint to a dummy url
          @notification_preferences = CertifyNotifications::NotificationPreference.find({id: 1})
          @error = CertifyNotifications.service_unavailable 'Excon::Error::Socket'
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@notification_preferences[:status]).to eq(@error[:status])
        end

        it "should return an error message" do
          expect(@notification_preferences[:body]).to eq(@error[:body])
        end
      end
    end
  end
end
