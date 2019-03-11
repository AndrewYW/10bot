require 'singleton'
require 'sqlite3'

class UsersDatabase < SQLite3::Database
  include Singleton

  DB_FILE = File.join(File.dirname(__FILE__), '../data/10bot.db')

  def self.open
    @database = SQLite3::Database.new(DB_FILE)
    @database.results_as_hash = true
    @database.type_translation = true
  end

  def self.instance
    UsersDatabase.open if @database.nil?
    @database
  end 

  def self.execute(*args)
    instance.execute(*args)
  end

  def self.get_first_row(*args)
    instance.get_first_row(*args)
  end

  def self.get_first_value(*args)
    instance.get_first_value(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end