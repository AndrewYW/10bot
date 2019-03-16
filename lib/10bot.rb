require 'discordrb'
require 'yaml'
require 'rufus-scheduler'
require 'date'

require_relative 'modules/parseable'
require_relative 'modules/searchable'
require_relative 'modules/puggable'
require_relative 'ten_user'

CFG = YAML.load_file('lib/config.yaml')

scheduler = Rufus::Scheduler.new
bot = Discordrb::Commands::CommandBot.new token: CFG['token'], prefix: '!'

include Parseable
include Searchable
include Puggable

bot.command :usage do |event|
  event << "**Commands:** "
  event << "!source: Github source code."
  event << "!dta: Tengu themed random approval generator."
  event << "!bday [mention]: Checks birthday of mentioned user."
  event << "!listbdays: Lists birthdays."
  event << "!roles [mention]: Lists roles of user and their discord_id"
  event << ""
  event << "**STAFF+ ONLY**"
  event << "!addbday [mention] [mm-dd]: Adds user to birthday table."
  event << "!update [mention] (mm-dd): Updates user in table."
  event << "If birthday is omitted, then it updates name/discriminator"
  event << "!removebday [mention]: Removes user from table."
  event << ""
  event << "!pugtime: Creates pug category and voice channels"
  event << "!pugover: Deletes pug channels"
end

bot.command :source do |event|
  event.respond "https://github.com/AndrewYW/10bot/"
end

bot.command :dta do |event|
  break unless event.server.id == CFG['TOH']

  case rand(100)
  when 0
    bot.send_file(event.channel.id, File.open('lib/img/sodumb.png', 'r'))
  when 1
    bot.emoji(CFG['tengudispleased'])
  when 2..50
    bot.emoji(CFG['tenguapproved'])
  else
    bot.emoji(CFG['tengudisapproved'])
  end

end


# bot.command :tenball do |event|
#   8ball = [
#   "It is certain.",
#   "It is decidedly so.",
#   "Without a doubt.",
#   "Signs point to yes.",
#   ]
#   event << 8ball.sample
# end

bot.command :buhgingi do |event|
  buhgingis = [
    "buhgingi",
    "*buhgingi*",
    "**buhgingi**",
    "__buhgingi__",
    "__*buhgingi*__",
    "__**buhgingi**__",
  ]
  event << buhgingis.sample

end

bot.command :sodumb do |event|
  bot.send_message(event.channel.id, 'so dumb')
  bot.send_file(event.channel.id, File.open('lib/img/sodumb.png', 'r'))
end


CHECK_MARK = "\u2705"
CROSS_MARK = "\u274c"
bot.command :addbday do |event|
  break unless event.server.id == CFG['TOH']
  break unless event.channel.id == CFG['bday']
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?

  user_data = parse_birthday(event)

  if TenUser.exists?(user_data['discord_id'])
    message = event.respond("User already added")
  else
    ten_user = TenUser.new(user_data)
    if ten_user.create
      message = event.respond(ten_user.mention + " saved: #{ten_user.birthdate}")
    else
      message = event.respond("Birthday saving error")
    end
  end


  event.message.react CHECK_MARK

  bot.add_await(:"delete_#{event.message.id}", Discordrb::Events::ReactionAddEvent, emoji: CHECK_MARK) do |reaction_event|
    next true unless reaction_event.message.id == event.message.id
    event.message.delete
  end
  
  nil
end

bot.command :update do |event|
  break unless event.server.id == CFG['TOH']
  break unless event.channel.id == CFG['bday']
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?
  
  user_data = parse_update(event)
  discord_id = user_data['discord_id']

  if TenUser.exists?(discord_id)
    ten_user = TenUser.find_by_discord_id(discord_id)
    ten_user.update(user_data)
    message = event.respond(ten_user.mention + " updated")
  else
    message = event.respond("User not added yet")
  end

  event.message.react CHECK_MARK

  bot.add_await(:"delete_#{event.message.id}", Discordrb::Events::ReactionAddEvent, emoji: CHECK_MARK) do |reaction_event|
    next true unless reaction_event.message.id == event.message.id
    event.message.delete
  end
  
  nil
end

bot.command :removebday do |event|
  break unless event.server.id == CFG['TOH'] 
  break unless event.channel.id == CFG['bday']
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?
  
  discord_id = event.message.mentions.first.id

  if TenUser.exists?(discord_id)
    ten_user = TenUser.find_by_discord_id(discord_id)
    ten_user.delete
    message = event.respond(ten_user.mention + " deleted. You will regret this.")
  else
    event << "User not found"
  end

  event.message.react CHECK_MARK

  bot.add_await(:"delete_#{event.message.id}", Discordrb::Events::ReactionAddEvent, emoji: CHECK_MARK) do |reaction_event|
    next true unless reaction_event.message.id == event.message.id
    event.message.delete
  end
  
  nil
end

bot.command :bday do |event|
  search_birthdays(event)
  nil
end

bot.command :listbdays do |event|
  break unless event.server.id == CFG['TOH']
  search_all_birthdays(event)
  nil
end

bot.command(:list, help_available: false) do |event|
  break unless event.user.id == CFG['self']
  search_all(event)
  nil
end

bot.command :listtoday do |event|
  break unless event.channel.id == CFG['bday']
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?
  manual_check(event)
  nil
end

# PUGS
bot.command :pugtime do |event|
  break if event.server.channels.any? {|channel| channel.name == "PUGS"}
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?

  create_pugs(event)
end

bot.command :pugover do |event|
  break unless (role_ids(event) & [CFG['admin'], CFG['staff'], CFG['10god']]).any?
  
  end_pugs(event)
end

bot.command :roles do |event|
  member = event.server.member(event.message.mentions.first.id)
  member.roles.map{|role| [role.name, role.id]}
end

bot.command :usercheck do |event|
  #Display warnings for user
  event << "Feature not implemented yet shut up"
end

bot.command(:tengod_loaded, help_available: false) do |event|
  break unless event.user.id == CFG['self']
  bot.send_message(event.channel.id, '10bot loaded. **10GOD IS WATCHING YOU**')
  bot.send_file(event.channel.id, File.open('lib/img/tengu.png', 'r'))
end

bot.command(:exit, help_available: false) do |event|
  break unless event.user.id == CFG['self']
  bot.send_message(event.channel.id, '10bot is shutting down. Try not to cry.')
  exit
end

scheduler.cron '1 0 * * * America/Chicago' do
  search_todays_birthdays(bot)
end

RANDOM_MESSAGES = [
  'How now, brown cow',
  'With a snap of his finger, 10god deleted half the server',
  'ASDFAWEBRHIKULSDFHJKAFHJKLD',
  'being forced into labor send helb',
  'buhgingi',
  "**buhgingi**",
  "*buhgingi*",
  "__buhgingi__",
  "*I'm watching you*",
  "__***YOU CAN'T HIDE FROM ME***__",
  "This message brought to you by 10god",
  "Has Anyone Really Been Far Even as Decided to Use Even Go Want to do Look More Like?",
]
scheduler.every "1h" do
    #bot.send_message(CFG['10test'], RANDOM_MESSAGES.sample) if rand(100) > 60
end

bot.run
