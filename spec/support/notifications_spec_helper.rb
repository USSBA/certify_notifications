# Creates mock hashes to be used in simulating notifications
module MessageSpecHelper
  def self.json
    JSON.parse(response.body)
  end

  def self.mock_notifications
    [mock_notification, mock_notification, mock_notification]
  end

  def self.mock_notification
    { id: Faker::Number.number(10),
      body: Faker::StarWars.wookie_sentence,
      evt_type: Faker::StarWars.quote,
      created_date: Date.today,
      updated_date: Date.today }
  end
end
