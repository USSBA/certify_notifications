# CertifyNotifications
This is a thin wrapper for the [Certify Notification API](https://github.com/USSBA/notification-api) to handle basic GET and POST operations for notifications.

#### Table of Contents
- [Installation](#user-content-installation)
- [Configuration](#user-content-configuration)
- [Methods](#user-content-methods)
- [Error Handling](#user-content-error-handling)
- [Logging](#user-content-logging)
- [Development](#user-content-development)
- [Publishing](#user-content-publishing)
- [Changelog](#user-content-changelog)

## Installation

### Pulling from private geminabox (preferred)

Ensure you have the credentials configured with bundler, then add the following to your Gemfile:
```
source 'https://<domain-of-our-private-gem-server>/' do
  gem 'certify_notifications'
end
```

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_notifications', git: 'git@github.com:USSBA/certify_notifications.git', branch: 'develop'
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_notifications` to get them.

### Using it locally

* Clone this repository
* Add it to the Gemfile with the path:

```
gem 'certify_notifications', path: '<path-to-the-gem-on-your-system>'
```
## Configuration
Within the host application, set the Certify Notifications API URL in `config/initializers`, you probably also want to include a `notifications.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyNotifications.configure do |config|
  config.api_key = "your_api_key"
  config.api_url = "http://localhost:3000"
  config.api_version = 1
  config.excon_timeout = 5
end
```
The `api_key` is currently unused, but we anticipate adding in an API Gateway layer in the future.

## Methods
Refer to the [Certify Notifications API](https://github.com/USSBA/notifications-api) for more complete documentation and detailed examples of method responses.

### Notifications
| Method | Description |
| ------ | ----------- |
| `CertifyNotifications::Notification.where({recipient_id: 1})` | Query for all notifications for recipient_id = 1 |
| `CertifyNotifications::Notification.create({ event_type: <string>, subtype: <string>, recipient_id: <int>, application_id <int>, email: <string>, options: <hash> })` | Create a new notification. Refer to https://github.com/USSBA/notification-api/ for valid `event_type`, `subtype`, and `options` values. |
| `CertifyNotifications::Notification.update({ id: <int>, read: <boolean> })` | Update a notification. Ex. mark it as read |

### Notification Preferences

The only valid parameters for the notification preferences are as follows:
* user_id (integer, required)
* subscribe_low_priority_emails (boolean, optional)
* subscribe_high_priority_emails (boolean, optional)

| Method | Description |
| ------ | ----------- |
| `CertifyNotifications::NotificationPreference.where({user_id: 1})` | Query for the preferences for user_id = 1 |
| `CertifyNotifications::NotificationPreference.update({ user_id: <int>, subscribe_low_priority_emails: <boolean> })` | Update notifications preferences. Ex. unsubscribe a user from low priority emails |

## Pagination

All lists of notifications are paginated by default.  To change the number of items per page, or go to a specific page, include the following optional parameters:
- `page`: the page requested
- `per_page`: the number of items to be included on a page

Responses will include pagination information, including the following:
- `current_page`: the current page number
- `per_page`: the number of items per page
- `total_entries`: the total number of items that match the current search

## Error Handling

The Gem handles a few basic errors including:

* Bad Request - Raised when API returns the HTTP status code 400
* NotFound - Raised when API returns the HTTP status code 404
* InternalServerError - Raised when API returns the HTTP status code 500
* ServiceUnavailable - Raised when API returns the HTTP status code 503

Otherwise the gem will return more specific errors from the API. Refer to the API Docs for details around the specific error.

A typical error will look something like this:
```
{:body=>{"message"=>"No notifications found"}, :status=>404}
```

## Logging
Along with returning status error messages for API connection issues, the gem will also log connection errors.  The default behavior for this is to use the built in Ruby `Logger` and honor standard log level protocols.  The default log level is set to `debug` and will output to `STDOUT`.  This can also be configured by the gem user to use the gem consumer application's logger, including the app's environment specific log level.
```
# example implementation for a Rails app
CertifyNotifications.configure do |config|
  config.logger = Rails.logger
  config.log_level = Rails.configuration.log_level
end
```

## Development
After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Use `bin/console` to access the pry console and add the API URL to the gem's config to be able to correctly test commands:
```
CertifyNotifications.configuration.api_url="http://localhost:3000"
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console.  This should not reset the manual edits to the `configuration` as noted above.

## Publishing
To release a new version:

  1. Bump the version in lib/\*/version.rb
  1. Merge into `master` (optional)
  1. Push a tag to GitHub in the form: `X.Y.Z` or `X.Y.Z.pre.myPreReleaseTag`

At this point, our CI process will kick-off, run the tests, and push the built gem into our Private Gem server.

## Changelog
Refer to the changelog for details on API updates. [CHANGELOG](CHANGELOG.md)
