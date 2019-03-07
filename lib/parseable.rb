#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(event)
    

    author = event.message.mentions.first
    birthdate = event.content.split(" ")[-1]

    { username: author.name, 
      discriminator: author.discriminator, 
      discord_id: author.id.to_s, 
      birthdate: birthdate}

  end

  def find_todays_birthdays

  end

end