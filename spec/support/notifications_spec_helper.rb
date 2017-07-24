# Creates mock hashes to be used in simulating notifications
module NotificationSpecHelper
  def self.json
    JSON.parse(response.body)
  end

  def self.mock_notifications
    [mock_notification, mock_notification, mock_notification]
  end

  def self.mock_notification
    { id: Faker::Number.number(10),
      recipient_id: Faker::Number.number(10),
      email: Faker::Internet.email,
      event_type: %w[application_state_change application_assignment access_request new_message].sample,
      subtype: %w['' submission accepted closed withdrawal].sample,
      read: Faker::Boolean.boolean,
      priority: false,
      options: nil }
  end
end
