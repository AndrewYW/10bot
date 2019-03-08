require_relative 'model_base'
require_relative 'users_db'
# require_relative 'warning'
class TenUser < ModelBase

  def self.find_by_id(id)
    user_data = UsersDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        ten_users.*
      FROM
        ten_users
      WHERE
        ten_users.id = :id
    SQL

    user_data.nil? ? nil : TenUser.new(user_data)
  end

  def self.find_by_discord_id(discord_id)
    user_data = UsersDatabase.get_first_row(<<-SQL, discord_id: discord_id)
      SELECT
        ten_users.*
      FROM  
        ten_users
      WHERE
        ten_users.discord_id = :discord_id
    SQL

    user_data.nil? ? nil : TenUser.new(user_data)
  end

  def self.find_all_birthdays
    user_data = UsersDatabase.execute(<<-SQL)
      SELECT
        ten_users.*
      FROM
        ten_users
      ORDER BY
        ten_users.username
    SQL

    user_data.map{|user| TenUser.new(user)}
  end

  def self.find_todays_birthdays
    current_day = Date.today.strftime('%F')[5..-1]

    user_data = UsersDatabase.execute(<<-SQL, current_day: current_day)
      SELECT
        ten_users.*
      FROM
        ten_users
      WHERE
        ten_users.birthdate = :current_day
    SQL

    user_data.map{|user| TenUser.new(user)}
  end

  def self.find_birthday(date)
    user_data = UsersDatabase.execute(<<-SQL, date: date)
      SELECT
        ten_users.*
      FROM
        ten_users
      WHERE
        ten_users.birthdate = :date
    SQL

    user_data.map{|user| TenUser.new(user)}
  end

  def self.mods
    mods = UsersDatabase.execute(<<-SQL)
      SELECT
        ten_users.*
      FROM
        ten_users
      WHERE
        ten_users.moderator = 1
    SQL

    mods.map{|mod| TenUser.new(mod)}
  end

  def self.admins
    TenUser.mods.select{|mod| mod.is_admin?}
  end

  attr_reader :id, :discord_id
  attr_accessor :username, :discriminator, :birthdate, :moderator, :administrator, :twitch_url
  def initialize(options={})
    @id, @discord_id, @username, @discriminator, @birthdate, @twitch_url, @moderator, @administrator = options.values_at(
      'id',
      'discord_id', 
      'username',
      'discriminator',
      'birthdate',
      'twitch_url',
      'moderator',
      'administrator'
    )
  end

  def attrs
    {
      discord_id: discord_id,
      username: username,
      discriminator: discriminator,
      birthdate: birthdate,
      twitch_url: twitch_url,
      moderator: moderator,
      administrator: administrator
    }
  end

  def is_mod?
    self.moderator == 1
  end

  def is_admin?
    self.administrator == 1
  end

  #add a warning to user
  def warn

  end

  def show_warnings

  end

  def as_discord_user
    
  end

  def as_discord_member

  end

  def birthday_info
    "#{username}##{discriminator} : #{birthdate}"
  end
end