# 10bot

10bot is a custom Discord server management bot written for a friend's Overwatch community server.
It uses the `discordrb` API wrapper and sqlite3 for database features (in file).
Since this is a custom Discord bot, implementation is actively managed by me,
and support for installation for other servers is not available.

## Background

Back in 2017 I ventured into writing Discord bots, starting with a basic Python bot for birthday tracking, using a TinyDB database
and hosting on a spare EC2 instance I had. I decided to revisit this base birthday tracking project for a multitude of reasons: wanting to take a deeper dive into Discord bots, practice with Ruby and writing my own ORM, creating a bot that didn't have horrendous looking code, etc.

### Features

+ Birthday management
  + 10bot tracks user entered birthdays, and makes an announcement the day of.
  + Staff can update user data, including username, discriminator, and birthdate.
+ PUG channel management  
  + 10bot creates and deletes voice channels for Overwatch Pickup games.
+ A host of dumb, inside joke commands

+ More features in the horizon...(in no particular order)
  + Starboard
  + User warnings, kicks, and bans
  + Polls
  + "Now live" for Twitch streamers in the server
  + Markov chain chatbot for shenanigans?
  + Overwatch League API integration for schedules and things

### Specifics

#### Database initialization

I used a shell script to initialize and setup the database, as well as seed with some Discord user data. The seed data is very specific and unnecessary, but was useful for testing before making 10bot live.

```shell
cat import_db.sql | sqlite3 data/10bot.db
cat seed_db.sql | sqlite3 data/10bot.db
```

#### Hiding the bot token

Apparently some people think it's funny to write web scrapers to find bot tokens to mess with peoples' servers. There are some standard methods to hide your bot token highlighted [here](https://github.com/meew0/discordrb/wiki/Methods-to-hide-your-bot's-token). 10bot uses the YAML method.

```ruby
#10bot.rb
require 'discordrb'
require 'yaml'

CFG = YAML.load_file('config.yaml')
bot = Discordrb::Bot.new token: CFG['token']
```

I used separate YAML files for production and development data. In addition to the bot token, my YAML files include discord_ids for various elements that are used within 10bot commands and features.

#### Custom ORM

I wrote my own ORM! Is it excessive for a birthday tracker? Definitely... but it was good practice, and makes the database implementation more modular for integrating future features. The ORM is formed from a few components: a `UsersDatabase` class that inherits `SQLite3::Database`, implementing the Singleton design pattern, a `ModelBase` class that uses an inflector to interact with the database, and a number of
Model classes that inherit from `ModelBase`. For just the birthday tracker, the only model implemented is a `ten_user` Class, which interfaces with the users table of the database.

```ruby
#users_db.rb
require 'singleton'
require 'sqlite3'

class UsersDatabase < SQLite3::Database
  include Singleton

  DB_FILE = File.join(File.dirname(__FILE__), '../data/10bot.db')

  def self.open
    @database = SQLite3::Database.new(DB_FILE)
    @database.results_as_hash = true
    @database.type_translation = true
  end

  def self.instance
    UsersDatabase.open if @database.nil?
    @database
  end 

  def self.execute(*args)
    instance.execute(*args)
  end

  def self.get_first_row(*args)
    instance.get_first_row(*args)
  end

  def self.get_first_value(*args)
    instance.get_first_value(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
```

### Dependencies

10bot uses several things made by people smarter than I am:

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