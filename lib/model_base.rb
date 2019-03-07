require 'discordrb'
require 'dry/inflector'
require_relative 'users_db'

class ModelBase

  def self.table
    inflector = Dry::Inflector.new
    inflector.tableize(self.to_s)
  end

  def self.find_by_id(id)
    data = UsersDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = :id
    SQL

    data.nil? ? nil : self.new(data)
  end
  
  def self.all
    data = UsersDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    parse_all(data)
  end

  def self.where(params)
    if params.is_a?(Hash)
      where_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")
      vals = params.values
    else
      where_line = params
      vals = []
    end

    data = UsersDatabase.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        #{where_line}
    SQL

    parse_all(data)
  end

  def self.find_by(params)
    self.where(params)
  end

  def self.first
    data = UsersDatabase.get_first_row(<<-SQL)
      SELECT
        *
      FROM
        #{table}
      LIMIT
        1
    SQL

    self.new(data)
  end

  def attrs
    Hash[instance_variables.map do |name|
      [name.to_s[1..-1], instance_variable_get(name)]
    end]
  end

  def save
    self.id ? update : create
  end

  def create
    raise 'already saved!' unless id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")
    col_names = instance_attrs.keys.join(", ")
    question_marks = (["?"] * instance_attrs.count).join(", ")
    values = instance_attrs.values

    UsersDatabase.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    @id = UsersDatabase.instance.last_insert_row_id
  end

  def update
    raise 'must create before updating' if id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")
    set_line = instance_attrs.keys.map { |attr| "#{attr} = ?" }.join(", ")
    values = instance_attrs.values

    UsersDatabase.execute(<<-SQL, *values, id)
      UPDATE
        #{self.class.table}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL

    self
  end

  def self.parse_all(data)
    data.map { |attrs| self.new(attrs) }
  end
end