require 'sqlite3'
require 'active_record'
require 'rubygems'

# Set up a database that resides in RAM
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: '../data/users.db'
)

# Set up database tables and columns
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :discord_id, null: false
    t.string :username
    t.text :birthday

    t.timestamps
  end


  create_table :warnings, force: true do |t|
    t.integer :user_id, null: false
    t.integer :mod_id, null: false
    t.text :warning_message, null: false

    t.timestamps
  end

  add_index :warnings, :user_id
  add_index :warnings, :mod_id
end

# Set up model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
class User < ApplicationRecord
  validates :discord_id, presence: true, uniqueness: true

  
  has_many :warnings,
    class_name: :Warning,
    foreign_key: :user_id

  
end
class Warning < ApplicationRecord
  belongs_to :user,
    class_name: :User,
    foreign_key: :user_id

  belongs_to :mod,
    class_name: :User,
    foreign_key: :mod_id
end