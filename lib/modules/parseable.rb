#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(event)
    user = event.message.mentions.first
    birthdate = event.content[/\d\d-\d\d$/]
    if birthdate.nil?
      event << "Birthdate parsing error"
    else
      role_ids = event.server.member(user.id).roles.map{|role| role.id}

      administrator = role_ids.include?(CFG['admin']) ? 1 : 0
      
      moderator = 0
      moderator = 1 if administrator == 1 or role_ids.include?(CFG['staff'])

      { 
        "discord_id" => user.id.to_s,
        "username" => user.name, 
        "discriminator" => user.discriminator, 
        "birthdate" => birthdate,
        "moderator" => moderator,
        "administrator" => administrator,
      }
    end
  end

  def parse_update(event)
    user = event.message.mentions.first
    birthdate = event.content[/\d\d-\d\d$/]
    
    role_ids = event.server.member(user.id).roles.map{|role| role.id}
    administrator = role_ids.include?(CFG['admin']) ? 1 : 0  
    moderator = 0
    moderator = 1 if administrator == 1 or role_ids.include?(CFG['staff'])

    { 
      "discord_id" => user.id.to_s,
      "username" => user.name, 
      "discriminator" => user.discriminator, 
      "birthdate" => birthdate.nil? ? TenUser.find_by_discord_id(user.id.to_s).birthdate : birthdate,
      "moderator" => moderator,
      "administrator" => administrator,
    }
  end

  def is_staff(event)

  end
end