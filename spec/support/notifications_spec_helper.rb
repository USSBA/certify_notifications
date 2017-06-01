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
      body: Faker::StarWars.wookie_sentence,
      link_url: Faker::Internet.url,
      evt_type: Faker::StarWars.quote,
      recipient_id: Faker::Number.number(10),
      read: Faker::Boolean.boolean,
      created_date: Date.today,
      updated_date: Date.today }
  end
end
