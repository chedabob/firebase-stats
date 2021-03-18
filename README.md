Firebase Stats
==============
[![Gem Version](https://badge.fury.io/rb/firebase-stats.svg)](https://badge.fury.io/rb/firebase-stats)

CLI that takes in the CSV exported by Firebase Analytics and spits out some stats

# Usage

Install with `gem install firebase-stats`

Then run `firebase-stats <command> <path to CSV file> <options>` (see below for commands and their respective options)

## Commands

### devices

Prints out usage by device model

`--platform` Filter by platform (`ios`, `android` or `all`)

`--friendly` Android model numbers are turned into their human readable names (e.g. SM-G991B becomes Samsung Galaxy S21 5G). This is slow as it downloads a file from Google each time, and the parsing speed isn't fantastic.

`--limit NUMBER` Limits the number of rows output (useful to speed up the `--friendly` option)


### os

Prints out usage by OS version

`--platform` Filter by platform (`ios`, `android` or `all`)

`--grouped` Group by major OS version

`--version-sorted` Sort by OS version rather than percentage

### gender

Prints out number of users of each gender

### gender_age

Prints out percentage of each gender grouped by age
