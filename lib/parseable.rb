#Returns hashes that are passed into queries

module Parseable
  def parse_birthday(str)
    array = str.split(" ")
    hash = {
      discord_id: array[1][2..-2],
      birthday: array[2]
    }
    user = create_10user(hash)
    user.save
  end

  def find_todays_birthdays

  end

  def create_10user(hash)
    member = bot.member(CONFIG['TOH'], hash['discord_id'])
    TenUser.new(hash.merge())
  end
end