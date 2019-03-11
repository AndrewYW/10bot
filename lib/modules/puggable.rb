module Puggable
  def create_pugs(event)
    pug_role = event.server.roles.find {|role| role.id == CFG['pug']}
    event << pug_role.mention
    event << event.user.mention + " HAS DECREED THERE WILL BE PUGS"
    category = event.server.create_channel("PUGS", 4)
    category.position = 1

    event.server.create_channel("pug-lobby", 2, { parent: category })
    event.server.create_channel("TEAM-1", 2, { parent: category })
    event.server.create_channel("TEAM-2", 2, { parent: category })

    nil
  end

  def end_pugs(event)
    pug_role = event.server.roles.find {|role| role.id == CFG['pug']}
    event << pug_role.mention
    event << event.user.mention + " HAS DECREED PUGS ARE OVER"

    category = event.server.channels.find {|channel| channel.name == "PUGS"}
    category.children.each{|channel| channel.delete}
    category.delete

    nil
  end
end