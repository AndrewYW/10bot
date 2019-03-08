#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(event)
    author = event.message.mentions.first
    birthdate = event.content[/\d\d-\d\d$/]
    if birthdate.nil?
      event << "Birthdate parsing error"
    else
      role_ids = event.server.member(author.id).roles.map{|role| role.id}

      administrator = role_ids.include?(CONFIG['admin']) ? 1 : 0
      
      moderator = 0
      moderator = 1 if administrator == 1 or role_ids.include?(CONFIG['staff'])

      { username: author.name, 
        discriminator: author.discriminator, 
        discord_id: author.id.to_s,
        moderator: moderator,
        administrator: administrator,
        birthdate: birthdate,
      }
    end
  end

end