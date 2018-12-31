#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(str)
    array = str.split(" ")
    hash = {
      discord_id: array[1][2..-2],
      birthday: array[2]
    }
    return hash
  end

  def find_todays_birthdays

  end
end