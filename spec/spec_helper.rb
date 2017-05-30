require "bundler/setup"
require "certify_notifications"
require "byebug"
require "faker"

Dir['./spec/support/**/*.rb'].each { |f| require f }

# configure the CertifyNotifications module for testing
CertifyNotifications.configure do |config|
  config.api_url = "http://foo.bar/"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Excon.defaults[:mock] = true
    Excon.stub({}, body: { message: 'Fallback stub response' }.to_json, status: 598)
  end
  config.after(:each) do
    Excon.stubs.clear
  end

end
