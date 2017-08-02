require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe "CertifyNotifications::Notification.create" do
  describe "create operations" do
    context "for creating new notifications" do
      before do
        @mock = NotificationSpecHelper.mock_notification
        Excon.stub({}, body: @mock.to_json, status: 201)
        @notification = CertifyNotifications::Notification.create(@mock)
        @body = @notification[:body]
      end

      it "should return the correct post response" do
        expect(@notification[:status]).to eq(201)
      end
      it "should return the correct notification object" do
        expect(@body[:id]).to eq(@mock["id"])
      end
    end

    context "handles errors" do
      context "empty parameters" do
        before do
          @bad_notification = CertifyNotifications::Notification.create
        end
        it 'should return a status code of 400' do
          expect(@bad_notification[:status]).to eq(CertifyNotifications.bad_request[:status])
        end

        it 'should return an error message' do
          expect(@bad_notification[:body]).to eq(CertifyNotifications.bad_request[:body])
        end
      end

      context "bad parameters" do
        before do
          @bad_notification = CertifyNotifications::Notification.create({foo: 'bar'})
        end
        it 'should return a status code of 422' do
          expect(@bad_notification[:status]).to eq(CertifyNotifications.unprocessable[:status])
        end

        it 'should return an error message' do
          expect(@bad_notification[:body]).to eq(CertifyNotifications.unprocessable[:body])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
          @notification = CertifyNotifications::Notification.create({id: 1})
          @error = CertifyNotifications.service_unavailable 'Excon::Error::Socket'
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end
        it "should return a 503" do
          expect(@notification[:status]).to eq(@error[:status])
        end

        it "should return an error message" do
          expect(@notification[:body]).to eq(@error[:body])
        end
      end
    end
  end
end
