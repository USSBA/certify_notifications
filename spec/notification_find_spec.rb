require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe "CertifyNotifications::Notification.find" do
  describe "get notifications operations" do
    context "for getting notifications" do
      before do
        @mock = NotificationSpecHelper.mock_notifications
        Excon.stub({}, body: @mock.to_json, status: 200)
        @notifications = CertifyNotifications::Notification.find({recipient_id: 1})
        @body = @notifications[:body]
      end

      it "will return a good status code" do
        expect(@notifications[:status]).to eq(200)
      end

      it "will return an array of notifications" do
        expect(@body.length).to be > 0
      end

      it "will contain valid notifications attributes" do
        expect(@body[0][:id]).to eq(@mock[0]["id"])
      end
    end

    context "handles errors" do
      context "no params" do
        before do
          @notifications = CertifyNotifications::Notification.find
          @body = @notifications[:body]
        end
        it "will return an error message" do
          expect(@body).to eq(CertifyNotifications.bad_request[:body])
        end
        it "will return a 400" do
          expect(@notifications[:status]).to eq(CertifyNotifications.bad_request[:status])
        end
      end

      context "bad parameters" do
        before do
          @notifications = CertifyNotifications::Notification.find({foo: 'bar'})
          @body = @notifications[:body]
        end
        it "will return an error message when a bad parameter is sent" do
          expect(@body).to eq(CertifyNotifications.unprocessable[:body])
        end

        it "will return a 422 http status" do
          expect(@notifications[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
          # reextend the endpoint to a dummy url
          @notifications = CertifyNotifications::Notification.find({id: 1})
          @error = CertifyNotifications.service_unavailable 'Excon::Error::Socket'
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "will return a 503" do
          expect(@notifications[:status]).to eq(@error[:status])
        end

        it "will return an error message" do
          expect(@notifications[:body]).to eq(@error[:body])
        end
      end
    end
  end
end
