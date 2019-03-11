require_relative '../ten_user';

module Searchable

  def search_all(event)
    TenUser.all.each do |user|
      event << user.birthday_info
    end
  end

  def search_all_birthdays(event)
    TenUser.find_all_birthdays.each do |user|
      event << user.birthday_info unless event.server.member(user.discord_id).nil?
    end
  end

  def search_birthdays(event)
    event.message.mentions.each do |user|
      res = TenUser.find_by_discord_id(user.id)
      if res.nil?
        event << user.mention + " not found"
      else
        event << res.birthday_info
      end
    end
  end

  def search_todays_birthdays(event)
    current_day = Date.today.strftime('%F')[5..-1]

    ten_users = TenUser.find_todays_birthdays(current_day)

    if ten_users
      event << "Today is: " + current_day
      event << "**THERE ARE SOME BIRTHDAYS TODAY**"
      members = ten_users.map{|user| user.as_discord_member(event)}

      members.each do |member|
        event << member.mention
      end
    else
      event << current_day + ": No birthdays today"
    end
  end

  def role_ids(event)
    event.user.roles.map {|role| role.id}
  end
end