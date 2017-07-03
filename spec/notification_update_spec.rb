require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe "CertifyNotifications::Notification.update" do

  describe 'Updating notifications' do
    context 'for editing message read/unread status' do
      before do
        notification = NotificationSpecHelper.mock_notification
        notification[:read] = true
        Excon.stub({}, body: notification.to_json, status: 201)
        @updated_notification_response = CertifyNotifications::Notification.update({
                                                                                     id: notification[:id],
                                                                                     read: notification[:read]
                                                                                   })
      end

      it "should return an updated notification" do
        expect(@updated_notification_response[:body]['read']).to be(true)
      end
    end
  end
end
