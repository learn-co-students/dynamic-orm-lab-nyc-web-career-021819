require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord

    self.column_names.each do |col_name|
        puts col_name.inspect
        attr_accessor col_name.to_sym
    end

    def initialize(attributes = {})
        attributes.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
    end

    def table_name_for_insert
    # return the table name when called on an instance of Student (FAILED - 1)
        self.class.table_name
    end

    def col_names_for_insert
        # return the column names when called on an instance of Student (FAILED - 2)
        # does not include an id column (FAILED - 3)
        self.class.column_names.delete_if {|col| col == "id"}.join(", ")
    end

    def values_for_insert
        values = []
        self.class.column_names.each do |col_name|
          values << "'#{send(col_name)}'" unless send(col_name).nil?
        end
        values.join(", ")
      end

    def save
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    
    DB[:conn].execute(sql)
    
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
    end

    def self.find_by_name(name)
        DB[:conn].execute("SELECT * FROM #{self.table_name} WHERE name = '#{name}'")
    end

    def self.find_by(attribute)
    # executes the SQL to find a row by the attribute passed into the method (FAILED - 8)
    # accounts for when an attribute value is an integer (FAILED - 9)
    puts attribute.inspect
    puts attribute.keys[0].inspect
    puts attribute.values[0].inspect
        DB[:conn].execute("SELECT * FROM #{self.table_name} WHERE #{attribute.keys[0].to_s} = '#{attribute.values[0]}'")
    
    end


end
