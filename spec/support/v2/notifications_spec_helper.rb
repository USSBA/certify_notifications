# Creates mock hashes to be used in simulating notifications
module V2
  module NotificationSpecHelper
    def self.json
      JSON.parse(response.body)
    end

    # helper to replace the rails symbolize_keys method
    def self.symbolize(hash)
      hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end

    def self.mock_recipient_uuid
      "11111111-1111-1111-1111-111111111111"
    end

    def self.mock_user_uuid
      "33333333-3333-3333-3333-333333333333"
    end

    def self.mock_notification_uuid
      "44444444-4444-4444-4444-444444444444"
    end

    def self.mock_notifications_sym
      [mock_notification_sym, mock_notification_sym, mock_notification_sym]
    end

    # notifications can be parameterized with keys as symbols, keys as strings or a mix of symbols and strings
    def self.mock_notification_types
      {
        symbol_keys: mock_notification_sym,
        string_keys: mock_notification_string,
        mixed_keys: mock_notification_mixed
      }
    end

    def self.mock_notification_sym
      { uuid: mock_notification_uuid,
        recipient_uuid: mock_recipient_uuid,
        application_id: Faker::Number.number(5),
        email: Faker::Internet.email,
        event_type: %w[application_state_change application_assignment access_request new_message].sample,
        subtype: %w['' submission accepted closed withdrawal].sample,
        read: Faker::Boolean.boolean,
        priority: false,
        options: nil }
    end

    def self.mock_notification_preference
      { id: Faker::Number.number(10),
        user_uuid: mock_user_uuid,
        subscribe_high_priority_emails: true,
        subscribe_low_priority_emails: true }
    end

    def self.mock_notification_string
      { "uuid" => mock_notification_uuid,
        "recipient_uuid" => mock_recipient_uuid,
        "application_id" => Faker::Number.number(5),
        "email" => Faker::Internet.email,
        "event_type" => %w[application_state_change application_assignment access_request new_message].sample,
        "subtype" => %w['' submission accepted closed withdrawal].sample,
        "read" => Faker::Boolean.boolean,
        "priority" => false,
        "options" => nil }
    end

    def self.mock_notification_mixed
      { uuid: mock_notification_uuid,
        recipient_uuid: mock_recipient_uuid,
        "application_id" => Faker::Number.number(5),
        "email" => Faker::Internet.email,
        "event_type" => %w[application_state_change application_assignment access_request new_message].sample,
        subtype: %w['' submission accepted closed withdrawal].sample,
        read: Faker::Boolean.boolean,
        priority: false,
        options: nil }
    end
  end
end
