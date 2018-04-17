# CHANGELOG

## 0.1.2 2018-04-17

### Changes

* Add automated backup tasks for all data storage containers.
    * Creates compressed backup files locally and syncs them to S3 buckets. Cleans out old backups.
* Adds documentation around backups and miscellaneous doc improvements.

### Known Issues

* VOIP/Video support is present but untested as of yet.

## 0.1.1 2018-04-16

### Changes

* Hotfix for issue with nginx reverse proxy.

### Known Issues

* VOIP/Video support is present but untested as of yet.

## 0.1.0 2018-04-16

### Changes

* Support for successful deployment via Nanobox.
* Support uploads and media stores via network volumes.
* Support using postgresql as a backend database.
* Can be used with Riot.fm and the Slack bridge.

### Known Issues

* VOIP/Video support is present but untested as of yet.
