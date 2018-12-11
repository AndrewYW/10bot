require 'sqlite3'
require 'singleton'

class UserDBConnection < SQLite3::Database
    include Singleton

    def initialize('~/data/users.rb')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User

    def self.all
        data = UserDBConnection.instance.execute("SELECT * FROM users")
        data.map{ |datum| User.new(datum)}
    end

    def initialize(options)
        
    end

    def create
    end

    def update
    end