require 'discordrb'
require 'yaml'
require 'rufus-scheduler'
require 'date'

require_relative 'parseable'
require_relative 'ten_user'

CONFIG = YAML.load_file('lib/test.yaml')

scheduler = Rufus::Scheduler.new
bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'], prefix: '!'

include Parseable

bot.command :user do |event|
  # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
  # but you have to be aware of this so you don't accidentally return something you didn't intend to.
  # To prevent the return value to be sent to the channel, you can just return `nil`.
  event.user.name
end

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

bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
  # The `if` statement returns one of multiple different things based on the condition. Its return value
  # is then returned from the block and sent to the channel
  if max
    rand(min.to_i..max.to_i)
  elsif min
    rand(0..min.to_i)
  else
    rand
  end
end

bot.command :long do |event|
  event << 'This is a long message.'
  event << 'It has multiple lines that are each sent by doing `event << line`.'
  event << 'This is an easy way to do such long messages, or to create lines that should only be sent conditionally.'
  event << 'Anyway, have a nice day.'

  # Here we don't have to worry about the return value because the `event << line` statement automatically returns nil.
end

bot.command :ping do |event|
  event.respond 'Pong :smile:'
end

bot.command :contents do |event|
  event.respond event.message
end



bot.command :dta do |event|
  # rand(2).zero? ? "<@#{CONFIG['tenguapproved']}>" : "<@#{CONFIG['tengudisapproved']}>"
  rand(2).zero? ? bot.emoji(CONFIG['tenguapproved']) : bot.emoji(CONFIG['tengudisapproved'])
end

bot.command :source do |event|
  event.respond "https://github.com/AndrewYW/10bot/"
end

# TODO #

#Display 
bot.command :usercheck do |event|

end

bot.command :addbday do |event|

  message = event.respond(parse_birthday(event))

  CROSS_MARK = "\u274c"

  message.react CROSS_MARK

  bot.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_MARK) do |reaction_event|
    next true unless reaction_event.message.id == message.id
    message.delete
  end
end

bot.command :bday do |event|
  author = event.message.mentions.first

  bday = "03-07"
  current_day = Date.today.strftime('%F')[5..-1]

  case bday == current_day
  when true
    "yes"
    mention_array = event.message.mentions
    mention_array.each do |user|
      event << event.server.member(user.id).roles.map{|role| [role.name, role.id]}
      # member = event.server.member(user.id) #can return nil 
      # event << "Hello #{member.mention}"
    end

    [author.name, author.discriminator, author.id.to_s]
  when false
    "nope"
  end
end

bot.command :id do |event|
  event << event.user.id
  event << event.message.id
end

bot.command :contents do |event|
  arr = event.content.split(" ")
  event.respond "#{arr[1][2..-2]}"
end


scheduler.cron '5 0 * * *' do
  bot.send_message(CONFIG['response_channel'], 'testing scheduler')
end

bot.run
