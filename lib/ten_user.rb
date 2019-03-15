require_relative 'model_base'
require_relative 'users_db'
require 'discordrb'
# require_relative 'warning'
class TenUser < ModelBase

  def self.exists?(discord_id)
    self.find_by_discord_id(discord_id).nil? ? false : true
  end

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
        ten_users.birthdate
    SQL

    user_data.map{|user| TenUser.new(user)}
  end

  def self.find_todays_birthdays(current_day)
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
  def initialize(options)
    keys = %w(discord_id username discriminator birthdate twitch_url moderator administrator)
    @discord_id, @username, @discriminator, @birthdate, @twitch_url, @moderator, @administrator = options.values_at(*keys)
  end

  def attrs
    {
      "discord_id" => self.discord_id,
      "username" => self.username,
      "discriminator" => self.discriminator,
      "birthdate" => self.birthdate,
      "twitch_url" => self.twitch_url,
      "moderator" => self.moderator,
      "administrator" => self.administrator,
    }
  end

  def create
    instance_attrs = attrs
    col_names = instance_attrs.keys.join(", ")
    question_marks = (["?"] * instance_attrs.count).join(", ")
    values = instance_attrs.values

    UsersDatabase.execute(<<-SQL, *values)
      INSERT INTO
        ten_users(#{col_names})
      VALUES
        (#{question_marks})
    SQL

    @id = UsersDatabase.last_insert_row_id
    self
  end

  def update(data)
    set_line = data.keys.map { |attr| "#{attr} = ?" }.join(", ")
    values = data.values

    UsersDatabase.execute(<<-SQL, *values, discord_id: self.discord_id)
      UPDATE
        ten_users
      SET
        #{set_line}
      WHERE
        ten_users.discord_id = :discord_id
    SQL

    self
  end

  def delete
    UsersDatabase.execute(<<-SQL, discord_id: self.discord_id)
      DELETE FROM
        ten_users
      WHERE 
        ten_users.discord_id = :discord_id
    SQL

    nil
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

  # def as_discord_user(bot)
  #   User.new({id: self.discord_id}, bot)
  # end
  # def as_discord_member(event)
  #   event.server.member(discord_id)
  # end

  def mention
    "<@#{self.discord_id}>"
  end

  def birthday_info
    "#{username}##{discriminator} : #{birthdate}"
  end
end