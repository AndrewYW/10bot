# 10bot

USING WHAT I LEARNED TO REDO WHAT I DID

## 10bot v1.0

10bot is a custom Discord server management bot written for a friend.
It uses the discordrb API wrapper and sqlite3 for database management.
Since this is a custom Discord bot, implementation is actively managed by me,
and support for installation for other servers is not available.

### Features

+ Birthday management
  + 10bot tracks user entered birthdays, and makes an announcement the day of.
+ PUG channel management
  + 10bot creates custom voice channels for Overwatch Pickup games.
+ A host of other dumb, but maybe useful features.

+ More features in the horizon...

### Dependencies

10bot uses several thingamabobs:

+ [discordrb](https://github.com/meew0/discordrb): Discord API wrapper in Ruby. 
+ [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler): Job scheduler for Ruby, supporting at, cron, in, and every jobs.
+ [dry-inflector](https://github.com/dry-rb/dry-inflector): Inflector gem for Ruby
+ [sqlite3](https://github.com/sparklemotion/sqlite3-ruby): Ruby interface for SQLite3

<!-- # TODO

## 10bot v0.1

This is just what comes to mind - not sure if there are/will be any usability issues...

### Admin Only

- !kick <user> <reason>
- !ban <user> <reason>
- !forgive <user> <# of warnings> <reason>

#### Admin Only - BIRTHDAYS
- !addbirthday <NOT SURE WHAT INPUT NEEDS TO GO HERE BUT LET ME KNOW>
- Probably needs to be like <@name> <mmdd>
- Announces in #general at 00:01 on <mmdd> with a message like "HAPPY BIRTHDAY <USER>!!"
!listbirthdays
- Shows list of <user>s and <birthday>
!removebirthday <user>

#### Admin Only - Starboard
- !starboardc <channel> sets channel for starboard
- !starboarde <emoji> sets emoji
- !starboardnum <#> sets how many <emoji>s you need for it to get posted on starboard
- !starboardlb shows leaderboard for top ten people who have stars?
- !starboardinfo shows channel and emoji and number needed for starboard post
- (NOT SURE WHAT ELSE IS NEEDED...)

#### Mod and Above
- !timeout <user> <reason> - do we need a time limit? probably? could that be abused tho?

- !warning <user> <reason>

- !usercheck - displays user data + warning #?

- !warningcheck - displays any <user>s that have any warnings (just number, no reason)

- !pugtime - creates a category of voice channels called PUGS and has PUGLOBBY TEAM 1 TEAM 2 

- Cannot be used to create multiple categories/voice channels

- !pugtimeover - deletes/hides above voice channels

#### Mod and Above - "NOWLIVE"
- !livec <channel> - sets channel
- !livemsg <message> - sets announcement message for all announcements
- !liveadd <twitchusername> - adds twitch user to be announced
- !liveremove <twitchusername> - removes twitch user from being announced
- !livelist - shows list of all twitch channels that will be announced

#### For fun/all
- !dta - "Does tengu approve?" Flips a coin (randnum < 50?) if heads displays :tenguapproved: if tails displays :tengudisapproved:



- Can you have 10bot run starboard?
- Can 10bot also track birthdays + announce birthdays? Maybe !addbirthday !removebirthday !listbirthdays -->