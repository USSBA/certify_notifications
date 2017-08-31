require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe CertifyNotifications do
  describe "get activity log operations" do

    context "with activity log params" do
      let(:mock) { NotificationSpecHelper.mock_notifications_sym }
      let(:activity_log) { CertifyNotifications::ActivityLog.where({application_id: 1}) }
      let(:body) { activity_log[:body] }

      before do
        Excon.stub({}, body: mock.to_json, status: 200)
      end

      it "will return a good status code" do
        expect(activity_log[:status]).to eq(200)
      end

      it "will return an array of notifications" do
        expect(body.length).to be > 0
      end

      it "will contain valid notifications attributes" do
        expect(body[0][:id]).to eq(mock[0]["id"])
      end
    end
  end
end
