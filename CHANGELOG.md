# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.1.1] - 2017-11-13
### shared-services-sprint-30
### Changed
  - HUB-960:
    - Fixes an incorrect require statement

## [1.1.0] - 2017-10-27
### shared-services-sprint-28
### Added
  - HUB-918:
    - Added custom configuration of `excon_timeout` and makes it available to be configured by gem user.
    - Sets Excon connection values for `connect_timeout`, `read_timeout` and `write_timeout` to equal value of `excon_timeout`
    - Added logger functionality to the gem, refer to README for more details about configuration.

## [1.0.3] - 2017-10-12
### shared-services-sprint-27
### Changed
  - HUB-868: Renamed method `find` to `where` for notifications call and add back an alias for `find`

  - HUB 859
    - Updated nokogiri and other dependencies


## [1.0.2] - 2017-09-28
### shared-services-sprint-26
### Added
This CHANGELOG file.

### Removed
- HUB-832: removed the experimental activity log API code since it's moving to its own repository.

## [1.0.1] - 2017-09-14
### shared-services-sprint-25

No functional change to the API.

### Added
- HUB-784: adds a placeholder to capture the output of `git describe` in the gemspec.

## [1.0.0] - 2017-08-31
### shared-services-sprint-24
