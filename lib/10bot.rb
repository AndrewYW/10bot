require 'discordrb'
require 'yaml'
require 'rufus-scheduler'
require 'date'

require_relative 'modules/parseable'
require_relative 'modules/searchable'
require_relative 'ten_user'

CONFIG = YAML.load_file('lib/test.yaml')

scheduler = Rufus::Scheduler.new
bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'], prefix: '!'

include Parseable
include Searchable

bot.command :bold do |_event, *args|
  # Again, the return value of the block is sent to the channel
  "**#{args.join(' ')}**"
end

bot.command :italic do |_event, *args|
  "*#{args.join(' ')}*"
end

bot.command(:invite, chain_usable: false) do |event|
  # This simply sends the bot's invite URL, without any specific permissions,
  # to the channel.
  event.bot.invite_url
end

bot.command :ping do |event|
  event.respond 'Pong :smile:'
end

bot.command :source do |event|
  event.respond "https://github.com/AndrewYW/10bot/"
end

bot.command :dta do |event|
  break unless event.server.id == CONFIG['TOH']
  rand(2).zero? ? bot.emoji(CONFIG['tenguapproved']) : bot.emoji(CONFIG['tengudisapproved'])
end


bot.command :addbday do |event|

  message = event.respond(parse_birthday(event).to_s)

  CROSS_MARK = "\u274c"
  CHECK_MARK = "\u2705"

  message.react CHECK_MARK

  bot.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CHECK_MARK) do |reaction_event|
    next true unless reaction_event.message.id == message.id
    message.delete
  end
  nil
end

bot.command :bday do |event|
  search_birthdays(event)
  nil
end

bot.command :list do |event|
  search_all_birthdays(event)
  nil
end

bot.command :roles do |event|
  member = event.server.member(event.message.mentions.first.id)
  member.roles.map{|role| [role.name, role.id]}
end

bot.command :usercheck do |event|
  #Display warnings for user
end

scheduler.cron '5 0 * * *' do
  bot.send_message(CONFIG['response_channel'], 'testing scheduler')
end

bot.run
