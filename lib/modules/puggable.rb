module Puggable
  def create_pugs(event)
    pug_role = event.server.roles.find {|role| role.id == CFG['pug']}
    event << pug_role.mention
    event << event.user.mention + " HAS DECREED THERE WILL BE PUGS"
    category = event.server.create_channel("PUGS", 4)
    category.position = 1

    first = event.content.split(" ")[1] || 'TEAM-1'
    second = event.content.split(" ")[2] || 'TEAM-2'

    event.server.create_channel("pug-lobby", 2, { parent: category, user_limit: 99 })
    event.server.create_channel(first, 2, { parent: category, user_limit: 12})
    event.server.create_channel(second, 2, { parent: category, user_limit: 12})

    nil
  end

  def end_pugs(event)
    pug_role = event.server.roles.find {|role| role.id == CFG['pug']}
    event << event.user.mention + " HAS DECREED PUGS ARE OVER"

    category = event.server.channels.find {|channel| channel.name == "PUGS"}
    category.children.each{|channel| channel.delete}
    category.delete

    nil
  end
end