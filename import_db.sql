-- Admin Only
-- !kick <user> <reason>
-- !ban <user> <reason>
-- !forgive <user> <# of warnings> <reason>

-- Mod and Above
-- !timeout <user> <reason>
-- !warning <user> <reason>
-- !usercheck - displays user data + warnings?
-- !pugtime - creates a category of voice channels called PUGS and has PUGLOBBY TEAM 1 TEAM 2 Cannot be used to create multiple categories/voice channels
-- !pugtimeover - deletes/hides above voice channels

-- For fun/all
-- !dta - "Does tengu approve?" Flips a coin (randnum < 50?) if heads displays :tenguapproved: if tails displays :tengudisapproved:

-- -Can you have 10bot run starboard?
-- -Can 10bot also track birthdays + announce birthdays? Maybe !addbirthday !removebirthday !listbirthdays

-- Chicago timezone is '-06:00'
-- East coast timezone is '-05:00'


-- *******DISCORD USER ATTRIBUTES********* https://discordapp.com/developers/docs/resources/user#usernames-and-nicknames
-- FIELD            TYPE        DESCRIPTION                                                 REQUIRED OAUTH2 SCOPE
---------------------------------------------------------------------------------------------------------------------
-- id	            snowflake	the user's id	                                            identify
-- username	        string	    the user's username, not unique across the platform	        identify
-- discriminator	string	    the user's 4-digit discord-tag	                            identify
-- avatar	        ?string	    the user's avatar hash	                                    identify
-- bot?	            boolean	    whether the user belongs to an OAuth2 application	        identify
-- mfa_enabled?	    boolean	    whether the user has two factor enabled on their account	identify
-- locale?	        string	    the user's chosen language option	                        identify
-- verified?	    boolean	    whether the email on this account has been verified	        email
-- email?	        string	    the user's email	                                        email
-- flags	        integer	    the flags on a user's account	                            identify
-- premium_type?	integer	    the type of Nitro subscription on a user's account      	identify
DROP TABLE IF EXISTS ten_users;
DROP TABLE IF EXISTS warnings;

PRAGMA foreign_keys = ON;

CREATE TABLE ten_users (
    id INTEGER PRIMARY KEY,
    discord_id TEXT NOT NULL UNIQUE,  --Discord id 
    username TEXT NOT NULL,         --NOT UNIQUE
    discriminator TEXT NOT NULL, --ALSO NOT UNIQUE
    birthdate TEXT,   
    twitch_url TEXT,       
    moderator INTEGER NOT NULL,
    administrator INTEGER NOT NULL
);

CREATE TABLE warnings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,      --NOT DISCORD ID
    mod_id INTEGER NOT NULL,       --ALSO NOT DISCORD ID
    warning_message TEXT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (mod_id) REFERENCES users(id)
);

-- CREATE TABLE stars(
--     id INTEGER PRIMARY KEY,
--     user_id INTEGER NOT NULL,
--     message_id INTEGER NOT NULL,    --Discord message id
-- );
