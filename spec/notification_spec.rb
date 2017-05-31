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

  # describe "create operations" do
  #   context "for creating new conversations" do
  #     before do
  #       @mock = MessageSpecHelper.mock_conversation
  #       Excon.stub({}, body: @mock.to_json, status: 201)
  #       @conversation = CertifyNotifications::Conversation.create(@mock)
  #       @body = @conversation[:body]
  #     end

  #     it "should return the correct post response" do
  #       expect(@conversation[:status]).to eq(201)
  #     end

  #     it "should return the new conversation object" do
  #       expect(@body["id"]).to eq(@mock[:id])
  #       expect(@body["application_id"]).to eq(@mock[:application_id])
  #       expect(@body["analyst_id"]).to eq(@mock[:analyst_id])
  #       expect(@body["contributor_id"]).to eq(@mock[:contributor_id])
  #       expect(@body["subject"]).to eq(@mock[:subject])
  #     end
  #   end

  #   context "handles errors" do

  #     context "empty parameters" do
  #       before do
  #         @conversation = CertifyNotifications::Conversation.create({})
  #         @body = @conversation[:body]
  #       end
  #       it "should return an error message when a no parameters are sent" do
  #         expect(@body).to eq("Invalid parameters submitted")
  #       end

  #       it "should return a 422 http status" do
  #         expect(@conversation[:status]).to eq(422)
  #       end
  #     end

  #     context "bad parameters" do
  #       before do
  #         @conversation = CertifyNotifications::Conversation.create({foo: 'bar'})
  #         @body = @conversation[:body]
  #       end
  #       it "should return an error message when a bad parameter is sent" do
  #         expect(@body).to eq("Invalid parameters submitted")
  #       end

  #       it "should return a 422 http status" do
  #         expect(@conversation[:status]).to eq(422)
  #       end
  #     end

  #     # this will work if the API is disconnected, but I can't figure out how to
  #     # fake the Excon connection to force it to fail in a test env.
  #     context "api not found" do
  #       before do
  #         CertifyNotifications::Resource.clear_connection
  #         Excon.defaults[:mock] = false
  #         @conversation = CertifyNotifications::Conversation.create({application_id: 1})
  #       end

  #       after do
  #         CertifyNotifications::Resource.clear_connection
  #         Excon.defaults[:mock] = true
  #       end

  #       it "should return a 503" do
  #         expect(@conversation[:status]).to eq(503)
  #       end
  #     end
  #   end

  #   context "should create a conversation with a new message" do
  #     context "when given good parameters" do
  #       before do
  #         @mock = MessageSpecHelper.mock_conversation
  #         @mock[:body] = Faker::HarryPotter.quote
  #         Excon.stub({}, body: @mock.to_json, status: 201)
  #         @response = CertifyNotifications::Conversation.create_with_message(@mock)
  #       end

  #       context "the newly created conversation" do
  #         it "should return 201" do
  #           expect(@response[:conversation][:status]).to eq(201)
  #         end

  #         it "should have the correct subject" do
  #           expect(@response[:conversation][:body][:subject]).to eq(@mock["subject"])
  #         end
  #       end

  #       context "the newly created message" do
  #         it "should return 201" do
  #           expect(@response[:message][:status]).to eq(201)
  #         end

  #         it "should have the correct body" do
  #           expect(@response[:message][:body]["body"]).to eq(@mock[:body])
  #         end
  #       end
  #     end

  #     context "when given bad parameters" do
  #       before do
  #         @mock = MessageSpecHelper.mock_conversation
  #         @mock[:subject] = nil
  #         Excon.stub({}, body: @mock.to_json, status: 422)
  #         @response = CertifyNotifications::Conversation.create_with_message(@mock)
  #       end

  #       context "the newly created conversation" do
  #         it "should return 422" do
  #           expect(@response[:conversation][:status]).to eq(422)
  #         end

  #         it "should have the correct subject" do
  #           expect(@response[:conversation][:body][:subject]).to eq(@mock["subject"])
  #         end
  #       end

  #       context "the newly created message" do
  #         it "should return 422" do
  #           expect(@response[:message][:status]).to eq(422)
  #         end

  #         it "should have an error message" do
  #           expect(@response[:message][:body]).to eq("An error occurred creating the conversation")
  #         end
  #       end
  #     end
  #   end
  # end
end
