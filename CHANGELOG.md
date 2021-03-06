# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project follows Wordpress versioning.

## [5.4.1] - 2020-05-03
### Changed
  - Upgrade Wordpress version to 5.4.1

## [5.3.0] - 2019-11-15
### Changed
  - Upgrade Wordpress version to 5.3.0

## [5.2.4] - 2019-10-15
### Changed
  - Upgrade Wordpress version to 5.2.4

## [5.2.3] - 2019-09-29
## Added
  - Multiarch support

### Changed
  - Upgrade Wordpress version to 5.2.3
  - Upgrade baseimage to web-baseimage:1.2.0 (debian buster)

## [5.2.1] - 2019-05-29
### Changed
  - Upgrade Wordpress version to 5.2.1

## [5.1.1] - 2019-03-14
### Changed
  - Upgrade Wordpress version to 5.1.1

## [5.0.3] - 2019-01-30
### Changed
  - Upgrade Wordpress version to 5.0.3

## [4.9.7] - 2018-07-28
### Changed
  - Upgrade Wordpress version to 4.9.7

## [4.9.6] - 2018-05-24
### Changed
  - Upgrade Wordpress version to 4.9.6

## [4.9.5] - 2018-04-05
### Changed
  - Upgrade Wordpress version to 4.9.5

## [4.9.4] - 2018-02-07
### Changed
  - Upgrade Wordpress version to 4.9.4

## [4.9.2] - 2018-01-29
### Changed
  - Upgrade Wordpress version to 4.9.2

## [4.9.1] - 2017-12-04
### Changed
  - Upgrade Wordpress version to 4.9.1

## [4.9.0] - 2017-11-30
### Changed
  - Upgrade Wordpress version to 4.9

## [4.8.3] - 2017-11-16
### Changed
  - Upgrade Wordpress version to 4.8.3

## [4.8.2] - 2017-10-31
### Added
  - WORDPRESS_DISABLE_XMLRPC environment variable

### Changed
  - Upgrade Wordpress version to 4.8.2
  - Upgrade baseimage to web-baseimage:1.1.1

## [4.8.1] - 2017-09-20
### Added
  - opcache config
  - WORDPRESS_REMOVE_DEFAULT_THEMES and WORDPRESS_REMOVE_DEFAULT_PLUGINS environment variables
  - WORDPRESS_PRODUCTION environment variable

### Changed
  - Upgrade Wordpress version to 4.8.1
  - Upgrade baseimage to web-baseimage:1.1.0 (debian stretch, php7)
  - Optimise apache config

## [4.8.0] - 2017-06-13
### Changed
  - Upgrade Wordpress version to 4.8

## [4.7.5] - 2017-05-17
### Changed
  - Upgrade Wordpress version to 4.7.5

## [4.7.4] - 2017-04-25
### Changed
  - Upgrade Wordpress version to 4.7.4

## [4.7.3] - 2017-03-07
### Changed
  - Upgrade Wordpress version to 4.7.3

### Fixed
  - startup.sh wp-config.php link
  - .htaccess overwrite

## [4.7.2] - 2017-02-22
### Added
  - wp-content
  - ldap tls config

### Changed
  - Upgrade baseimage to web-baseimage:1.0.0
  - Upgrade Wordpress version to 4.7.2

## Versions before following the Wordpress versioning

## [0.1.2] - 2015-03-03
### Fixed
  - bootstrap config

## [0.1.1] - 2015-03-02
### Added
  - SSL certs directory
  - Bootstrap capabilities

## 0.1.0 - 2015-02-23
Initial release

[5.4.1]: https://github.com/osixia/docker-wordpress/compare/v5.3.0...v5.4.1
[5.3.0]: https://github.com/osixia/docker-wordpress/compare/v5.2.4...v5.3.0
[5.2.4]: https://github.com/osixia/docker-wordpress/compare/v5.2.3...v5.2.4
[5.2.3]: https://github.com/osixia/docker-wordpress/compare/v5.2.1...v5.2.3
[5.2.1]: https://github.com/osixia/docker-wordpress/compare/v5.1.1...v5.2.1
[5.1.1]: https://github.com/osixia/docker-wordpress/compare/v5.0.3...v5.1.1
[5.0.3]: https://github.com/osixia/docker-wordpress/compare/v4.9.7...v5.0.3
[4.9.7]: https://github.com/osixia/docker-wordpress/compare/v4.9.6...v4.9.7
[4.9.6]: https://github.com/osixia/docker-wordpress/compare/v4.9.5...v4.9.6
[4.9.5]: https://github.com/osixia/docker-wordpress/compare/v4.9.4...v4.9.5
[4.9.4]: https://github.com/osixia/docker-wordpress/compare/v4.9.2...v4.9.4
[4.9.2]: https://github.com/osixia/docker-wordpress/compare/v4.9.1...v4.9.2
[4.9.1]: https://github.com/osixia/docker-wordpress/compare/v4.9.0...v4.9.1
[4.9.0]: https://github.com/osixia/docker-wordpress/compare/v4.8.3...v4.9.0
[4.8.3]: https://github.com/osixia/docker-wordpress/compare/v4.8.2...v4.8.3
[4.8.2]: https://github.com/osixia/docker-wordpress/compare/v4.8.1...v4.8.2
[4.8.1]: https://github.com/osixia/docker-wordpress/compare/v4.8.0...v4.8.1
[4.8.0]: https://github.com/osixia/docker-wordpress/compare/v4.7.5...v4.8.0
[4.7.5]: https://github.com/osixia/docker-wordpress/compare/v4.7.4...v4.7.5
[4.7.4]: https://github.com/osixia/docker-wordpress/compare/v4.7.3...v4.7.4
[4.7.3]: https://github.com/osixia/docker-wordpress/compare/v4.7.2...v4.7.3
[4.7.2]: https://github.com/osixia/docker-wordpress/compare/v0.1.2...v4.7.2
[0.1.2]: https://github.com/osixia/docker-wordpress/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/osixia/docker-wordpress/compare/v0.1.0...v0.1.1
