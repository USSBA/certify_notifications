# CertifyNotifications

This is a thin wrapper for the [Certify Notification API](https://github.com/SBA-ONE/notification-api) to handle basic GET and POST operations for notifications.


#### Table of Contents
- [Installation](#user-content-installation)
- [Usage](#user-content-usage)
    - [Configuration](#user-content-configuration)
    - [Notifications](#user-content-notifications)
    - [Notification Preferences](#user-content-notification-preferences)
- [Error Handling](#user-content-error-handling)
- [Logging](#logging)
- [Pagination](#user-content-pagination)
- [Development](#user-content-development)
- [Changelog](#changelog)

## Installation

There are two options you can use to install the gem. Building it manually, or installing from GitHub.

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_notifications', git: 'git@github.com:SBA-ONE/certify_notifications.git', branch: 'develop' # Certify notification service
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify-notifications` to get them.

### Building it manually

* Pull down the latest branch for the gem
* `bundle install` to build it
* You can run tests `rspec` to make sure it built okay.
* Then `rake build` to build the gem, this builds the .gem file in /pkg
* Jump over to the folder of the the app where you want to use them and follow the instructions below within that app/repo, for example, if working with the [Shared-Services Prototype](https://github.com/SBA-ONE/shared-services-prototype):
  * Copy the .gem into the folder `vendor/gems/certify_notifications`
  * In the app where you want to use the gem, do `gem install <path to gem>` e.g. `gem install vendor/gems/certify_notifications/certify_notifications-0.1.0.gem`
  * add `gem 'certify_notifications'` to your Gemfile
  * `bundle install`
  * If this worked correctly, you should see `certify_notifications` in your `Gemfile.lock`

## Usage

### Configuration
Set the notifications API URL in your apps `config/initializers` folder, you probably also want to include a `notifications.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyNotifications.configure do |config|
  config.api_url = "http://localhost:3004"
  config.notify_api_version = 1
  config.excon_timeout = 5
end
```
With [v1.1.0](CHANGELOG.md#110---2017-10-28), the default Excon API connection timeout was lowered to `20 seconds`. The gem user can also provide a timeout value in seconds as shown above in the `configure` block.  This value is used for the Excon parameters `connect_timeout`, `read_timeout`, and `write_timeout`.

### Notifications

#### Finding (GET) Notifications
* calling `CertifyNotifications::Notification.where({recipient_id: 1})` will query for all notifications for recipient_id = 1
* Calling the `.where` method with empty or invalid parameters will result in an error (see below)

#### Creating (POST) Notifications
* to create a new notification, the following parameters are required:
```
  CertifyNotifications::Notification.create({
    event_type: <string>,
    subtype: <string>
    recipient_id: <int>,
    application_id <int>,
    email: <string>,
    options: <hash>
  })
```
* and with optional parameters
```
  CertifyNotifications::Notification.create({
    event_type: <string>,
    subtype: <string>
    recipient_id: <int>,
    application_id <int>,
    email: <string>,
    options: <hash>,
    certify_link: <string>,
    priority: <boolean>
  })
```
* refer to https://github.com/USSBA/notification-api/ for valid `event_type`, `subtype`, and `options` values
* This will return a JSON hash with a `body` containing the data of the notification along with `status` of 201.
* Calling the `.create` method with empty or invalid parameters will result in an error (see below)

#### Updating (PUT) Notifications
* to update a notification,for example to mark it as read:
```
  CertifyNotifications::Notification.update({
    id: <int>,
    read: <boolean>
  })
```
  * This will return a status of 204.
* Calling the `.update` method with empty or invalid parameters will result in an error (see below)

### Notification Preferences

#### Valid Parameters

The only valid parameters for the notification preferences are as follows:
* user_id (integer, required)
* subscribe_low_priority_emails (boolean, optional)
* subscribe_high_priority_emails (boolean, optional)

#### Finding (GET) Notification Preferences
* calling `CertifyNotifications::NotificationPreference.where({user_id: 1})` will query for the preferences for user_id = 1
* Calling the `.where` method with empty or invalid parameters will result in an error (see below)
* NOTE: if no preference object is found, one is created with default values and returned

#### Updating (PUT) Notification Preferencess
* to update a notification preference,for example to unsubscribe from low priority emails (i.e., digest emails):
```
  CertifyNotifications::NotificationPreference.update({
    user_id: <int>,
    subscribe_low_priority_emails: <boolean>
  })
```
  * This will return a status of 204.
* Calling the `.update` method with empty or invalid parameters will result in an error (see below)

## Error Handling
* Calling a Gem method with no or empty parameters, e.g.:
```
CertifyNotifictions::Notification.where  {}
CertifyNotifictions::Notification.create {}
CertifyNotifictions::Notification.update {}
```
will return a bad request:
`{body: "Bad Request: No parameters submitted", status: 400}`
* Calling a Gem method with invalid parameters:
```
CertifyNotifictions::Notification.where  {foo: 'bar'}
CertifyNotifictions::Notification.create {foo: 'bar'}
CertifyNotifictions::Notification.update {foo: 'bar'}
```
will return an unprocessable entity error:
`{body: "Unprocessable Entity: Invalid parameters submitted", status: 422}`
* Any other errors that the Gem experiences when connecting to the API will return a service error and the Excon error class:
`    {body: "Service Unavailable: There was a problem connecting to the notifications API. Type: Excon::Error::Socket", status: 503}`

## Logging
Along with returning status error messages for API connection issues, the gem will also log connection errors.  The default behavior for this is to use the built in Ruby `Logger` and honor standard log level protocols.  The default log level is set to `debug` and will output to `STDOUT`.  This can also be configured by the gem user to use the gem consumer application's logger, including the app's environment specific log level.
```
# example implementation for a Rails app
CertifyNotifications.configure do |config|
  config.logger = Rails.logger
  config.log_level = Rails.configuration.log_level
end
```

## Pagination

All lists of notifications are paginated by default.  To change the number of items per page, or go to a specific page, include the following optional parameters:
- `page`: the page requested
- `per_page`: the number of items to be included on a page

Responses will include pagination information, including the following:
- `current_page`: the current page number
- `per_page`: the number of items per page
- `total_entries`: the total number of items that match the current search

## Development
Use `rake console` to access the pry console and add the messages API URL to the gem's config to be able to correctly test commands:
```
  CertifyNotifications.configuration.api_url = 'http://localhost:3004'
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console.
Byebug is included for debugging and can be called by inserting `byebug` inline.


## Changelog
Refer to the changelog for details on API updates. [CHANGELOG](CHANGELOG.md)
