require 'spec_helper'

RSpec.describe CertifyNotifications, type: :feature do
  describe "setting the api_key header" do
    let(:connection) { CertifyNotifications::Resource.connection }

    after do
      CertifyNotifications::Resource.clear_connection
    end

    context "when api_key not set" do
      before do
        CertifyNotifications.configuration.api_key = nil
      end

      it "will not have the api-key header set" do
        expect(connection.conn.data[:headers]['x-api-key']).to be_nil
      end
    end

    context "when api_key is set" do
      before do
        CertifyNotifications.configuration.api_key = 'my-special-api-key'
      end

      it "will have the api-key header set" do
        expect(connection.conn.data[:headers]['x-api-key']).to eq('my-special-api-key')
      end
    end
  end
end
