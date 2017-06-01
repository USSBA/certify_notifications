require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe CertifyNotifications::Notification do
  describe "get notifications operations" do
    context "for getting notifications" do
      before do
        @mock = NotificationSpecHelper.mock_notifications
        Excon.stub({}, body: @mock.to_json, status: 200)
        @notifications = CertifyNotifications::Notification.find({recipient_id: 1})
        @body = @notifications[:body]
      end

      it "should return a good status code" do
        expect(@notifications[:status]).to eq(200)
      end

      it "should return an array of notifications" do
        expect(@body.length).to be > 0
      end

      it "should contain valid notifications attributes" do
        expect(@body[0]["body"]).to be
        expect(@body[0]["evt_type"]).to be
        expect(@body[0]["recipient_id"]).to be
      end
    end

    context "handles errors" do
      before do
        @notifications = CertifyNotifications::Notification.find({foo: 'bar'})
        @body = @notifications[:body]
      end

      context "bad parameters" do
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq("Invalid parameters submitted")
        end

        it "should return a 400 http status" do
          expect(@notifications[:status]).to eq(400)
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
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@notifications[:status]).to eq(503)
        end
      end

    end
  end

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

      it "should return the new notification object" do
        expect(@body["id"]).to eq(@mock[:id])
        expect(@body["body"]).to eq(@mock[:body])
        expect(@body["link_url"]).to eq(@mock[:link_url])
        expect(@body["evt_type"]).to eq(@mock[:evt_type])
        expect(@body["recipient_id"]).to eq(@mock[:recipient_id])
        expect(@body["read"]).to eq(@mock[:read])
      end
    end

    context "handles errors" do
      context "empty parameters" do
        before do
          @notification = CertifyNotifications::Notification.create({})
          @body = @notification[:body]
        end
        it "should return an error message when a no parameters are sent" do
          expect(@body).to eq("Invalid parameters submitted")
        end

        it "should return a 422 http status" do
          expect(@notification[:status]).to eq(422)
        end
      end

      context "bad parameters" do
        before do
          @notification = CertifyNotifications::Notification.create({foo: 'bar'})
          @body = @notification[:body]
        end
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq("Invalid parameters submitted")
        end

        it "should return a 422 http status" do
          expect(@notification[:status]).to eq(422)
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = false
          @notification = CertifyNotifications::Notification.create({id: 1})
        end

        after do
          CertifyNotifications::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@notification[:status]).to eq(503)
        end
      end
    end
  end

  # describe "update notification status" do
  #   context "create a new notification" do
  #     before do
  # rubocop:disable Metrics/LineLength
  #       @mock = { id: "1", body: "Ru wyogg hnn-rowr roooarrgh roo ga wua ooma hnn-rowr?", link_url: "http://gislasonerdman.io/addie.rath", evt_type: "labmda", recipient_id: "5285887782", read: false }
  #       Excon.stub({}, body: @mock.to_json, status: 201)
  #       @notification = CertifyNotifications::Notification.create(@mock)
  #       @body = @notification[:body]
  #     end

  #     it "should return the correct post response" do
  #       expect(@notification[:status]).to eq(201)
  #     end

  #     it "should originally have a status of unread" do
  #       expect(@body["read"]).to eq(false)
  #     end
  #     context "update that notification" do
  #       before do
  #         @mock = { id: "1", body: "Ru wyogg hnn-rowr roooarrgh roo ga wua ooma hnn-rowr?", link_url: "http://gislasonerdman.io/addie.rath", evt_type: "labmda", recipient_id: "5285887782", read: true }
  #         Excon.stub({}, body: @mock.to_json, status: 201)
  #         @notification = CertifyNotifications::Notification.create(@mock)
  #         @body = @notification[:body]
  #       end
  #     end
  #   end
  # end

end
