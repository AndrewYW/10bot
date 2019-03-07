#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(event)
    author = event.message.mentions.first
    birthdate = event.content[/\d\d-\d\d$/]
    if birthdate.nil?
      event << "Birthdate parsing error"
    else
      { username: author.name, 
        discriminator: author.discriminator, 
        discord_id: author.id.to_s, 
        birthdate: birthdate
      }
    end
  end

end