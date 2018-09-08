require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    @columns = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      cats
    SQL
    @columns = @columns.first.map { |column| column.to_sym }
  end

  def self.finalize!
    columns.each do |column|
      # column = column.to_s
      define_method(column) do
        attributes[column]
      end
      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.all
    hash = DBConnection.execute(<<-SQL)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    SQL
    parse_all(hash)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    WHERE
      id = ?
    SQL
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |key, value|
      # raise unless attributes.has_key?(key)
      self.send(key, value)
    end
  end

  def attributes
    return @attributes if @attributes
    @attributes = {}
  end

  def attribute_values
    # ...
  end

  def insert

  end

  def update
    # ...
  end

  def save
    # ...
  end
end
