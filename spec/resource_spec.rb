require "spec_helper"

RSpec.describe CertifyNotifications do
  context "testing basic resource params" do
    let!(:timeout) { 100 }
    let!(:url) { described_class.configuration.api_url }
    let(:connection) { described_class::ApiConnection.new url, timeout }
    let(:params) { connection.conn.params }

    it "has correct connect_timeout" do
      expect(params[:connect_timeout]).to eq(timeout)
    end

    it "has correct write_timeout" do
      expect(params[:write_timeout]).to eq(timeout)
    end

    it "has correct read_timeout" do
      expect(params[:read_timeout]).to eq(timeout)
    end
  end
end
