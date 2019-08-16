require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord
  
  def self.table_name
    self.to_s.downcase.pluralize
  end
  
  def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    
    DB[:conn].execute(sql)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end
  
  
  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
    DB[:conn].execute(sql)
  end
  
<<<<<<< HEAD
  def self.find_by(parameters)
    # #parameters.each do |key, val|
    # #binding.pry
     sql = "SELECT * FROM #{self.table_name} WHERE #{parameters.keys.first} = '#{parameters.values.first.to_s}'"
     DB[:conn].execute(sql)
    
   end
=======
  def self.find_by(parameters={})
    # sql = "SELECT * FROM #{self.table_name} WHERE '#{x}' = '#{y}'"
    # DB[:conn].execute(sql, x, y)
    parameters.each do |key, val|
      sql = "SELECT * FROM #{self.table_name} WHERE key = val"
      DB[:conn].execute(sql, parameters)
    end
  end
>>>>>>> be05afb1e91f20274d86b114ab5eb0295b47397e
  
  
  def self.column_names
    DB[:conn].results_as_hash = true
    
    sql = "PRAGMA table_info('#{table_name}')"
    
    table_info = DB[:conn].execute(sql)
    
    column_names = []
    
    table_info.each do |column|
      column_names << column["name"]
    end
    
    column_names.compact
  end
  
  def table_name_for_insert
    self.class.table_name
  end
  
  def col_names_for_insert
    self.class.column_names.delete_if {|column| column == "id"}.join(", ")
  end
  
  def values_for_insert
    values = []
    
    self.class.column_names.each do |column_name|
      values << "'#{send(column_name)}'" unless send(column_name).nil?
    end
    values.join(", ")
  end
  
  
end