require_relative 'ten_user';

module Searchable

  def search_all_birthdays(event)
    TenUser.all.each do |user|
      event << user.birthday_info unless event.server.member(user.discord_id).nil?
    end
  end

  def search_birthdays(event)
    event.message.mentions.each do |user|
      res = TenUser.find_by_discord_id(user.id)
      event << res.birthday_info unless res.nil?
    end
  end

end