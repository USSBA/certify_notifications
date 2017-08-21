# Creates mock hashes to be used in simulating notifications
module NotificationSpecHelper
  def self.json
    JSON.parse(response.body)
  end

  # helper to replace the rails symbolize_keys method
  def self.symbolize(hash)
    hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
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
    { id: Faker::Number.number(10),
      recipient_id: Faker::Number.number(10),
      email: Faker::Internet.email,
      event_type: %w[application_state_change application_assignment access_request new_message].sample,
      subtype: %w['' submission accepted closed withdrawal].sample,
      read: Faker::Boolean.boolean,
      priority: false,
      options: nil }
  end

  def self.mock_notification_string
    { "id" => Faker::Number.number(10),
      "recipient_id" => Faker::Number.number(10),
      "email" => Faker::Internet.email,
      "event_type" => %w[application_state_change application_assignment access_request new_message].sample,
      "subtype" => %w['' submission accepted closed withdrawal].sample,
      "read" => Faker::Boolean.boolean,
      "priority" => false,
      "options" => nil }
  end

  def self.mock_notification_mixed
    { id: Faker::Number.number(10),
      recipient_id: Faker::Number.number(10),
      "email" => Faker::Internet.email,
      "event_type" => %w[application_state_change application_assignment access_request new_message].sample,
      subtype: %w['' submission accepted closed withdrawal].sample,
      read: Faker::Boolean.boolean,
      priority: false,
      options: nil }
  end
end
