# 10bot

USING WHAT I LEARNED TO REDO WHAT I DID

# TODO

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
- Can 10bot also track birthdays + announce birthdays? Maybe !addbirthday !removebirthday !listbirthdays